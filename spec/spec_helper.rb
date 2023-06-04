# frozen_string_literal: true

require 'simplecov'

require_relative '../lib/sensible_logging'
require_relative '../lib/sensible_logging/version'
require_relative '../lib/sensible_logging/middlewares/request_id'
require_relative '../lib/sensible_logging/middlewares/request_logger'
require_relative '../lib/sensible_logging/middlewares/tagged_logger'
require_relative '../lib/sensible_logging/helpers/subdomain_parser'

ENV['RACK_ENV'] = 'test'

# A multipart form that exceeds rack's multipart form limit.
def invalid_multipart_body
  # rubocop:disable Style/StringConcatenation
  # rubocop:disable Layout/LineLength
  Rack::Utils.multipart_part_limit.times.map do
    "--myboundary\r\ncontent-type: text/plain\r\ncontent-disposition: attachment; name=#{SecureRandom.hex(10)}; filename=#{SecureRandom.hex(10)}\r\n\r\ncontents\r\n"
  end.join("\r\n") + "--myboundary--\r"
  # rubocop:enable Layout/LineLength
  # rubocop:enable Style/StringConcatenation
end
