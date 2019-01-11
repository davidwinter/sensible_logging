# frozen_string_literal: true

require 'rack/request'

# Captures information around  request
class RequestLogger
  def initialize(app, filtered_params = [])
    @app = app
    @filtered_params = filtered_params
  end

  def call(env) # rubocop:disable Metrics/AbcSize
    req = Rack::Request.new(env)
    start_time = Time.now
    status, headers, body = @app.call(env)
    end_time = Time.now - start_time

    client_ip = req.ip || 'n/a'

    message = "method=#{req.request_method} path=#{req.path} client=#{client_ip} status=#{status} duration=#{end_time}"
    filtered_params = filter_params(req)
    message += " params=#{filtered_params}" if req.get? && !filtered_params.empty?
    env['logger'].info(message)
    [status, headers, body]
  end

  private

  def filter_params(req)
    req.params.reject { |x| @filtered_params.include?(x) }
  end
end
