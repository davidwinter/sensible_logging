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
  subject(:middleware) do
    described_class.new(
      dummy_app,
      logger: logger,
      tags: tags,
      use_default_tags: use_default_tags,
      tld_length: tld_length,
      include_log_severity: include_log_severity
    )
  end

  let(:app) { instance_double('App', call: [200, {}, []]) }
  let(:log_output) { StringIO.new }
  let(:logger) { Logger.new(log_output) }
  let(:dummy_app) { DummyApp.new(app) }
  let(:tags) { [] }
  let(:use_default_tags) { true }
  let(:include_log_severity) { true }
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

    expect(log_output.string).to eq("[INFO] [n/a] [#{ENV['RACK_ENV']}] [123ABC] hello\n")
  end

  it 'ignores IP address hosts' do
    env = Rack::MockRequest.env_for('http://192.168.1.1/path')
    env['request_id'] = '123ABC'
    middleware.call(env)

    expect(log_output.string).to eq("[INFO] [192.168.1.1] [#{ENV['RACK_ENV']}] [123ABC] hello\n")
  end

  context 'when disabling log severity' do
    let(:include_log_severity) { false }

    it 'will not include log severity' do
      env = Rack::MockRequest.env_for('http://192.168.1.1/path')
      env['request_id'] = '123ABC'
      middleware.call(env)

      expect(log_output.string).to eq("[192.168.1.1] [#{ENV['RACK_ENV']}] [123ABC] hello\n")
    end
  end

  context 'with nested subdomains' do
    let(:tld_length) { 2 }

    it 'logs 2 subdomains deep' do
      env = Rack::MockRequest.env_for('http://www.blah.google.co.uk/path')
      env['request_id'] = '123ABC'
      middleware.call(env)

      expect(log_output.string).to eq("[INFO] [www.blah] [#{ENV['RACK_ENV']}] [123ABC] hello\n")
    end
  end
end
