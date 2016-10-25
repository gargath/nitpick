# frozen_string_literal: true
require 'jwt'

# Middleware for validating incoming JWT signatures
class JWTValidator
  JWT_SECRET = SecureRandom.base64(256)

  def initialize(app)
    log('INFO', 'JWT Validator initialized')
    @app = app
  end

  def call(env)
    token = env['HTTP_AUTHORIZATION']
    if token
      begin
        JWT.decode token, JWT_SECRET
        env['nitpick_token'] = token
      rescue JWT::VerificationError
        return Rack::Response.new(
          'Invalid Token',
          401,
          'Content-Length' => '13', 'X-JWT-ERROR' => 'Invalid Signature'
        )
      rescue JWT::DecodeError
        return Rack::Response.new(
          'Malformed Token',
          401,
          'Content-Length' => '15', 'X-JWT-ERROR' => 'Malformed Token'
        )
      end
    end
    @app.call(env)
  end

  private

  def log(level, line)
    puts "[#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}] #{level} #{line}"
  end
end
