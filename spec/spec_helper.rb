require_relative '../lib/middlewares/request_id'
require_relative '../lib/middlewares/request_logger'
require_relative '../lib/middlewares/tagged_logger'

ENV['RACK_ENV'] = 'test'
