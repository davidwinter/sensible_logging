require_relative '../lib/sensible_logging/version'
require_relative '../lib/sensible_logging/middlewares/request_id'
require_relative '../lib/sensible_logging/middlewares/request_logger'
require_relative '../lib/sensible_logging/middlewares/tagged_logger'

ENV['RACK_ENV'] = 'test'
