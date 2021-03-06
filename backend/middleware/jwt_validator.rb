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
    auth_header = env['HTTP_AUTHORIZATION']
    token = auth_header.split[1] if auth_header
    if token
      begin
        decode = JWT.decode token, JWT_SECRET
        env['nitpick_token'] = decode[0]
      rescue JWT::VerificationError
        logger.info("[#{env['request_id']}] - Invalid Signature in request \
          [#{env['REQUEST_METHOD']} #{env['REQUEST_PATH']}] from #{env['REMOTE_ADDR']}")
        return Rack::Response.new(
          'Invalid Token',
          401,
          'Content-Length' => '13', 'X-JWT-ERROR' => 'Invalid Signature'
        )
      rescue JWT::DecodeError
        logger.info("[#{env['request_id']}] - Malformed Token (#{token}) \
          in request [#{env['REQUEST_METHOD']} #{env['REQUEST_PATH']}] from #{env['REMOTE_ADDR']}")
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
