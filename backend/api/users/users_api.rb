# frozen_string_literal: true
require 'grape'
require 'bcrypt'
require_relative '../log_helper.rb'
require_relative '../auth_helper.rb'

module Nitpick
  # API for querying system status
  class UsersAPI < Grape::API

    include BCrypt

    prefix 'users'
    content_type :json, 'application/json'
    version 'v1', using: :path
    default_format :json

    helpers LogHelper
    helpers AuthHelper

    params do
      requires :user, type: Hash do
        requires :username, type: String
        requires :email, type: String
        requires :password, type: String
      end
    end
    post '/' do
      u =  declared(params)[:user]
      error! "User '#{u[:username]}' already exists", 409 if User.exists?(username: u[:username])
      new_user = User.create({username: u[:username], email: u[:email], password: Password.create(u[:password]), status: 0})
      begin
        new_user.save
      rescue ActiveRecordError => e
        Rollbar.error('ActiveRecordError while trying to save new user', e, { username: u[:username], request_id: env['request_id'] })
        error! 'Failed to persist new user', 500
      end
      { id: new_user.id, username: new_user.username, email: new_user.email }
    end

    get '/' do
      authenticate!
      response = []
      User.all.each do |user|
        response << { 'id': user.id, 'username': user.username }
      end
      response
    end
  end
end
