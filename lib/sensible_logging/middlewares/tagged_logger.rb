require 'active_support/tagged_logging'

class TaggedLogger
  def initialize(app, logger = Logger.new(STDOUT), tags = [])
    @app = app
    @logger = ActiveSupport::TaggedLogging.new(logger)

    @tags = tags
    @tags = self.class.default_tags if tags.empty?
  end

  def call(env)
    @logger.tagged(*generate_tags(env)) do |logger|
      env['logger'] = logger
      @app.call(env)
    end
  end

  def self.default_tags
    [lambda { |req|
      [req.host, ENV['RACK_ENV'], req.env['request_id']]
    }]
  end

  private

  def generate_tags(env)
    req = Rack::Request.new(env)
    tags = @tags.map do |tag|
      tag.call(req)
    end
  end
end
