# frozen_string_literal: true

require 'ipaddr'
require 'active_support/tagged_logging'
require_relative '../helpers/subdomain_parser'

# Allow custom tags to be captured
class TaggedLogger
  def initialize(app, opts = {})
    @app = app

    options = default_options(opts)

    options[:logger] = setup_severity_tag(options[:logger]) if options[:include_log_severity]

    @logger = ActiveSupport::TaggedLogging.new(options[:logger])
    @tags = []
    @tags += default_tags(tld_length: options[:tld_length]) if options[:use_default_log_tags]
    @tags += options[:tags]
  end

  def call(env)
    @logger.tagged(*generate_tags(env)) do |logger|
      env['logger'] = logger
      @app.call(env)
    end
  end

  private

  def default_options(opts)
    {
      logger: Logger.new(STDOUT),
      tags: [],
      use_default_log_tags: true,
      tld_length: 1,
      include_log_severity: true
    }.merge(opts)
  end

  def setup_severity_tag(logger)
    logger.formatter = proc do |severity, _datetime, _progname, msg|
      "[#{severity}] #{msg}\n"
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
