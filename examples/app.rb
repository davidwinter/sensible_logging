# frozen_string_literal: true

require 'sinatra/base'
require 'logger'

require_relative '../lib/sensible_logging'

# Example Sinatra app
class App < Sinatra::Base
  register Sinatra::SensibleLogging

  sensible_logging(
    logger: Logger.new(STDOUT),
    log_tags: [->(req) { [req.port] }],
    exclude_params: ['two']
  )

  configure do
    set :log_level, Logger::DEBUG
  end

  configure :production do
    set :log_level, Logger::INFO
  end

  get '/hello' do
    logger.debug('test')
    'test'
  end

  post '/' do
    logger.debug('posting')
    'posted'
  end
end
