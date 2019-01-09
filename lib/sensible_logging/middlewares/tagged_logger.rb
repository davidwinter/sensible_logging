require 'ipaddr'
require 'active_support/tagged_logging'
require_relative '../helpers/subdomain_parser'

class TaggedLogger
  def initialize(app, logger = Logger.new(STDOUT), tags = [], use_default_log_tags = true, tld_length = 1)
    @app = app
    @logger = ActiveSupport::TaggedLogging.new(logger)

    @tags = []
    @tags += default_tags(tld_length: tld_length) if use_default_log_tags
    @tags += tags
  end

  def call(env)
    @logger.tagged(*generate_tags(env)) do |logger|
      env['logger'] = logger
      @app.call(env)
    end
  end

  private

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
    tags = @tags.map do |tag|
      tag.call(req)
    end
  end
end
