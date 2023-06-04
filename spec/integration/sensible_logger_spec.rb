# frozen_string_literal: true

require 'rack/mock'
require 'sinatra/base'

class App < Sinatra::Base
  register Sinatra::SensibleLogging

  configure do
    set :log_level, Logger::DEBUG
  end

  sensible_logging(
    logger: Logger.new(IO::NULL),
    log_tags: [->(req) { [req.port] }],
    exclude_params: ['two']
  )

  error(Rack::Multipart::MultipartPartLimitError) do
    halt(413, "You've exceeded the multipart part limit.")
  end

  get '/hello' do
    logger.tagged('todo') do |logger|
      logger.debug('test')
      env['rack.errors'].puts('This is an example error')
    end
    'test'
  end
end

describe 'Sensible Logging integrated with Sinatra' do # rubocop:disable RSpec/DescribeClass
  it 'request returns 200' do
    env = Rack::MockRequest.env_for('http://www.blah.google.co.uk/hello')
    app = App.new

    response = app.call(env)

    expect(response[0]).to eq(200)
  end

  context 'when encountering multipart error' do
    let(:env) do
      data = invalid_multipart_body

      Rack::MockRequest.env_for('http://www.blah.google.co.uk/hello', {
                                  'CONTENT_TYPE' => 'multipart/form-data; boundary=myboundary',
                                  'CONTENT_LENGTH' => data.bytesize,
                                  input: StringIO.new(data)
                                })
    end

    it 'does not rescue error when show_exceptions is enabled' do
      app = App.new
      app.settings.show_exceptions = true

      expect { app.call(env) }.to raise_error(Rack::Multipart::MultipartPartLimitError)
    end

    it 'does rescue error when show_exceptions is disabled' do
      app = App.new
      app.settings.show_exceptions = false

      response = app.call(env)

      expect(response[0]).to eq(413)
    end
  end
end
