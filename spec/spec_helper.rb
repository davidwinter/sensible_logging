# frozen_string_literal: true

require 'simplecov'

require_relative '../lib/sensible_logging/version'
require_relative '../lib/sensible_logging/middlewares/request_id'
require_relative '../lib/sensible_logging/middlewares/request_logger'
require_relative '../lib/sensible_logging/middlewares/tagged_logger'
require_relative '../lib/sensible_logging/helpers/subdomain_parser'

ENV['RACK_ENV'] = 'test'
