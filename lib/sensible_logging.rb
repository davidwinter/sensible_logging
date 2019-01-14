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
      opts
    )
      options = default_options(opts)

      setup_middlewares(options)

      before do
        env['rack.errors'] = env['rack.logger'] = env['logger']
        logger.level = settings.log_level unless settings.log_level.nil?
      end
    end

    private

    def setup_middlewares(options)
      use RequestId
      use(
        TaggedLogger,
        logger: options[:logger],
        tags: options[:log_tags],
        use_default_log_tags: options[:use_default_log_tags],
        tld_length: options[:tld_length],
        include_log_severity: options[:include_log_severity]
      )
      use RequestLogger, options[:exclude_params]
    end

    def default_options(opts)
      {
        logger: Logger.new(STDOUT),
        log_tags: [],
        use_default_log_tags: true,
        exclude_params: [],
        tld_length: 1,
        include_log_severity: true
      }.merge(opts)
    end
  end

  register SensibleLogging
end
