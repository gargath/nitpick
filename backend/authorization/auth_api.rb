# frozen_string_literal: true
require 'grape'
require 'jwt'

# API for handling authentication and auth validation
class AuthAPI < Grape::API
  HMAC_SECRET = 'FpCuZc-LghBgmx*2+Yyk4KXABxPu9P'
  prefix 'auth'
  content_type :json, 'application/json'
  version 'v1', using: :path
  default_format :json

  helpers do
    def logger
      NitpickAPI.logger
    end
  end

  post :login do
    params do
      requires :username, type: String
      requires :password, type: String
    end

    username = params[:username]
    password = params[:password]

    error! 'Required Parameter Missing', 422 unless username && password

    logger.info "Login request from user #{params[:username]}"
    if params[:password] == 'pass'
      status 200
      { authtoken: JWT.encode(
        { username: params[:username], password: params[:password] },
        HMAC_SECRET,
        'HS256'
      ) }
    else
      error! 'Unrecognized Credentials', 403
    end
  end
end
