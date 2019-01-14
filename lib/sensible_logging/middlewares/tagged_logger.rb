# frozen_string_literal: true

require 'ipaddr'
require 'active_support/tagged_logging'
require_relative '../helpers/subdomain_parser'

# Allow custom tags to be captured
class TaggedLogger
  def initialize( # rubocop:disable Metrics/ParameterLists
    app,
    logger: Logger.new(STDOUT),
    tags: [],
    use_default_tags: true,
    tld_length: 1,
    include_log_severity: true
  )
    @app = app

    logger = setup_severity_tag(logger) if include_log_severity

    @logger = ActiveSupport::TaggedLogging.new(logger)
    @tags = []
    @tags += default_tags(tld_length: tld_length) if use_default_tags
    @tags += tags
  end

  def call(env)
    @logger.tagged(*generate_tags(env)) do |logger|
      env['logger'] = logger
      @app.call(env)
    end
  end

  private

  def setup_severity_tag(logger)
    original_formatter = logger.formatter || ActiveSupport::Logger::SimpleFormatter.new
    logger.formatter = proc do |severity, *args|
      "[#{severity}] #{original_formatter.call(severity, *args)}"
    end
    logger
  end

  def default_tags(tld_length: 1)
    [lambda { |req|
      [subdomain(req.host, tld_length) || 'n/a', ENV['RACK_ENV'], req.env['request_id']]
    }]
  end

  def subdomain(host, tld_length)
    IPAddr.new(host)
  rescue IPAddr::InvalidAddressError
    subdomain_parser = SubdomainParser.new(tld_length: tld_length)
    subdomain_parser.parse(host)
  end

  def generate_tags(env)
    req = Rack::Request.new(env)
    @tags.map do |tag|
      tag.call(req)
    end
  end
end
