# frozen_string_literal: true

require 'sinatra/base'

require_relative './sensible_logging/middlewares/request_id'
require_relative './sensible_logging/middlewares/tagged_logger'
require_relative './sensible_logging/middlewares/request_logger'

module Rack
  # Disable Rack::CommonLogger
  class CommonLogger
    def call(env)
      @app.call(env)
    end
  end
end

# Sinatra extension
module Sinatra
  # Sensible logging library for Sinatra based Apps
  module SensibleLogging
    def sensible_logging(
      logger: Logger.new(STDOUT),
      log_tags: [],
      use_default_log_tags: true,
      exclude_params: [],
      tld_length: 1
    )
      use RequestId
      use TaggedLogger, logger, log_tags, use_default_log_tags, tld_length
      use RequestLogger, exclude_params

      before do
        env['rack.errors'] = env['rack.logger'] = env['logger']
        logger.level = settings.log_level unless settings.log_level.nil?
      end
    end
  end

  register SensibleLogging
end
