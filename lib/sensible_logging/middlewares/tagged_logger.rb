require 'active_support/tagged_logging'

class TaggedLogger
  def initialize(app, logger = Logger.new(STDOUT), tags = [], tld_length = 1)
    @app = app
    @logger = ActiveSupport::TaggedLogging.new(logger)

    @tags = tags
    @tags = default_tags if tags.empty?

    @tld_length = tld_length
  end

  def call(env)
    @logger.tagged(*generate_tags(env)) do |logger|
      env['logger'] = logger
      @app.call(env)
    end
  end

  def default_tags
    [lambda { |req|
      [subdomain(req), ENV['RACK_ENV'], req.env['request_id']]
    }]
  end

  private

  def subdomain(req)
    domain_parts = req.host.split('.')

    main_domain_length = @tld_length + 1
    subdomain_length = domain_parts.length - main_domain_length

    domain_parts[0...subdomain_length].join('.')
  end

  def generate_tags(env)
    req = Rack::Request.new(env)
    tags = @tags.map do |tag|
      tag.call(req)
    end
  end
end
