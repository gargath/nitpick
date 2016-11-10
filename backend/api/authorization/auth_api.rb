# frozen_string_literal: true
require 'grape'
require 'jwt'
require_relative '../../middleware/jwt_validator.rb'
require_relative '../log_helper.rb'
require_relative '../../model/user.rb'

module Nitpick
  # API for handling authentication and auth validation
  class AuthAPI < Grape::API
    HMAC_SECRET = JWTValidator::JWT_SECRET
    prefix 'auth'
    content_type :json, 'application/json'
    version 'v1', using: :path
    default_format :json

    helpers LogHelper

    params do
      requires :username, type: String
      requires :password, type: String
    end
    post :login do
      user = User.find_by username: params[:username]
      if user && user.password == params[:password] && user.status.positive?
        logger.info format("Successful login request from user #{params[:username]}")
        status 200
        { authtoken: JWT.encode(
          { username: params[:username], timestamp: Time.now.to_i },
          HMAC_SECRET,
          'HS256'
        ) }
      elsif user && user.status.zero?
        logger.info format("Login request from unconfirmed user #{params[:username]}")
        error!({ 'error' => 'User not validated' }, 403)
      else
        logger.info format("Failed login request from user #{params[:username]}")
        error!({ 'error' => 'Unrecognized Credentials' }, 403)
      end
    end
  end
end
