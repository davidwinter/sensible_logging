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
end
