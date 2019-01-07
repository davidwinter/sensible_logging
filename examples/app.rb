require 'sinatra/base'
require 'logger'

class App < Sinatra::Base
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
