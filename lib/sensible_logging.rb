require_relative './sensible_logging/middlewares/request_id'
require_relative './sensible_logging/middlewares/tagged_logger'
require_relative './sensible_logging/middlewares/request_logger'

def sensible_logging(app:, logger:, log_tags: [], exclude_params: [], tld_length: 1)
  use RequestId
  use TaggedLogger, logger, log_tags, tld_length
  use RequestLogger, exclude_params

  app.before do
    env['rack.errors'] = env['rack.logger'] = env['logger']
    if app.settings.log_level != nil
      logger.level = app.settings.log_level
    end
  end

  app
end
