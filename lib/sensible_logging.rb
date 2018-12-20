require './lib/middlewares/request_id'
require './lib/middlewares/tagged_logger'
require './lib/middlewares/request_logger'

def sensible_logging(app:, logger:, log_tags: [], exclude_params: [])
  use RequestId
  use TaggedLogger, logger, log_tags
  use RequestLogger, exclude_params

  app.before do
    env['rack.errors'] = env['rack.logger'] = env['logger']
    if app.settings.log_level != nil
      logger.level = app.settings.log_level
    end
  end

  app
end
