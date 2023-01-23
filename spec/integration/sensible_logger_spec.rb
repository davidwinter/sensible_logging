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

  context 'request_logger encountering multipart error' do
    let(:env) do
      data = invalid_multipart_body
      env = Rack::MockRequest.env_for('http://www.blah.google.co.uk/hello', {
        'CONTENT_TYPE' => 'multipart/form-data; boundary=myboundary',
        'CONTENT_LENGTH' => data.bytesize,
        input: StringIO.new(data)
      })
    end

    it 'does not rescue error when show_exceptions is enabled' do
      klass = Class.new(App) do
        configure { set :show_exceptions, true }
        error(Rack::Multipart::MultipartPartLimitError) do
          halt(413, "You've exceeded the multipart part limit.")
        end
      end
      app = klass.new

      err = begin
        app.call(env)
      rescue => e
        err = e
      end

      expect(err.class).to be(Rack::Multipart::MultipartPartLimitError)
    end

    it 'does rescue error when show_exceptions is disabled' do
      klass = Class.new(App) do
        configure { set :show_exceptions, false }
        error(Rack::Multipart::MultipartPartLimitError) do
          halt(413, "You've exceeded the multipart part limit.")
        end
      end
      app = klass.new

      response = app.call(env)

      expect(response[0]).to eq(413)
    end
  end
end