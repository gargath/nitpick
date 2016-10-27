# frozen_string_literal: true
require 'jwt'

# Middleware for validating incoming JWT signatures
class JWTValidator
  JWT_SECRET = SecureRandom.base64(256)

  def initialize(app)
    @app = app
  end

  def call(env)
    logger = env['logger']
    token = env['HTTP_AUTHORIZATION']
    if token
      begin
        decode = JWT.decode token, JWT_SECRET
        env['nitpick_token'] = decode
      rescue JWT::VerificationError
        logger.error("[#{env['request_id']} - Invalid Signature}]")
        return Rack::Response.new(
          'Invalid Token',
          401,
          'Content-Length' => '13', 'X-JWT-ERROR' => 'Invalid Signature'
        )
      rescue JWT::DecodeError
        logger.error("[#{env['request_id']} - Malformed Token (#{token})}]")
        return Rack::Response.new(
          'Malformed Token',
          401,
          'Content-Length' => '15', 'X-JWT-ERROR' => 'Malformed Token'
        )
      end
    end
    @app.call(env)
  end
end
