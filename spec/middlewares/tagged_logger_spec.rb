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
  let(:app) { double(:app, call: [200, {}, []]) }
  let(:log_output) { StringIO.new }
  let(:logger) { Logger.new(log_output) }
  let(:dummy_app) { DummyApp.new(app) }

  it 'assigns the logger to env' do
    env = Rack::MockRequest.env_for('http://www.blah.google.co.uk/path')
    env['request_id'] = '123ABC'

    described_class.new(dummy_app, logger, [], true, 2).call(env)

    expect(env['logger']).to_not eq(nil)
    expect(log_output.string).to eq("[www.blah] [#{ENV['RACK_ENV']}] [123ABC] hello\n")
  end

  it 'works with non-subdomain hosts' do
    env = Rack::MockRequest.env_for('http://google.com/path')
    env['request_id'] = '123ABC'

    described_class.new(dummy_app, logger, [], true).call(env)

    expect(env['logger']).to_not eq(nil)
    expect(log_output.string).to eq("[n/a] [#{ENV['RACK_ENV']}] [123ABC] hello\n")
  end
end
