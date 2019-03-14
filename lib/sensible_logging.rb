# frozen_string_literal: true

require 'sinatra/base'

require_relative './sensible_logging/middlewares/request_id'
require_relative './sensible_logging/middlewares/tagged_logger'
require_relative './sensible_logging/middlewares/request_logger'
require_relative './sensible_logging/helpers/logger_io_wrap'

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
    def sensible_logging( # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists
      logger: Logger.new(STDOUT),
      log_tags: [],
      use_default_log_tags: true,
      exclude_params: [],
      tld_length: 1,
      include_log_severity: true
    )
      setup_middlewares(
        logger: logger,
        log_tags: log_tags,
        use_default_log_tags: use_default_log_tags,
        exclude_params: exclude_params,
        tld_length: tld_length,
        include_log_severity: include_log_severity
      )

      before do
        env['rack.logger'] = env['logger']
        env['rack.errors'] = IOWrap.new(logger, level: Logger::ERROR)
        logger.level = settings.log_level unless settings.log_level.nil?
      end
    end

    private

    def setup_middlewares( # rubocop:disable Metrics/ParameterLists
      logger:,
      log_tags:,
      use_default_log_tags:,
      exclude_params:,
      tld_length:,
      include_log_severity:
    )
      use RequestId
      use(
        TaggedLogger,
        logger: logger,
        tags: log_tags,
        use_default_tags: use_default_log_tags,
        tld_length: tld_length,
        include_log_severity: include_log_severity
      )
      use RequestLogger, exclude_params
    end
  end

  register SensibleLogging
end
