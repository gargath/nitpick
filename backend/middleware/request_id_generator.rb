# frozen_string_literal: true

# Middleware for assigning requests unique IDs and returning them in a header
class RequestIdGenerator
  def initialize(app)
    @app = app
  end

  def call(env)
    started_at = Time.now
    req_id = Digest::MD5.hexdigest(started_at.to_f.to_s + $PID.to_s + rand(128).to_s)
    env['logger'].debug("[#{req_id}] - Processing started")
    env['request_id'] = req_id
    status, headers, body = @app.call(env)
    headers['X-Request-Id'] = req_id
    env['logger'].debug("[#{req_id}] - Complete (took #{Time.now - started_at}s)")
    [status, headers, body]
  end
end
