# frozen_string_literal: true

require 'securerandom'

# Captures request id
class RequestId
  def initialize(app)
    @app = app
  end

  def call(env)
    env['request_id'] = env['HTTP_X_REQUEST_ID'] || new_request_id
    status, headers, body = @app.call(env)
    headers['X-Request-Id'] ||= env['request_id']
    [status, headers, body]
  end

  private

  def new_request_id
    SecureRandom.uuid
  end
end
