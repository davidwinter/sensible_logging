# frozen_string_literal: true

require 'rack/mock'
require 'stringio'

class DummyApp
  def initialize(app)
    @app = app
  end

  def call(env)
    env['logger'].info('hello')

    @app.call(env)
  end
end

describe TaggedLogger do
  subject(:middleware) { described_class.new(dummy_app, logger, tags, use_default_tags, tld_length) }

  let(:app) { instance_double(:app, call: [200, {}, []]) }
  let(:log_output) { StringIO.new }
  let(:logger) { Logger.new(log_output) }
  let(:dummy_app) { DummyApp.new(app) }
  let(:tags) { [] }
  let(:use_default_tags) { true }
  let(:tld_length) { 1 }

  it 'assigns the logger to env' do
    env = Rack::MockRequest.env_for('http://www.blah.google.co.uk/path')
    env['request_id'] = '123ABC'
    middleware.call(env)

    expect(env['logger']).not_to eq(nil)
  end

  it 'works with non-subdomain hosts' do
    env = Rack::MockRequest.env_for('http://google.com/path')
    env['request_id'] = '123ABC'
    middleware.call(env)

    expect(log_output.string).to eq("[n/a] [#{ENV['RACK_ENV']}] [123ABC] hello\n")
  end

  it 'ignores IP address hosts' do
    env = Rack::MockRequest.env_for('http://192.168.1.1/path')
    env['request_id'] = '123ABC'
    middleware.call(env)

    expect(log_output.string).to eq("[192.168.1.1] [#{ENV['RACK_ENV']}] [123ABC] hello\n")
  end

  context 'with nested subdomains' do
    let(:tld_length) { 2 }

    it 'logs 2 subdomains deep' do
      env = Rack::MockRequest.env_for('http://www.blah.google.co.uk/path')
      env['request_id'] = '123ABC'
      middleware.call(env)

      expect(log_output.string).to eq("[www.blah] [#{ENV['RACK_ENV']}] [123ABC] hello\n")
    end
  end
end
