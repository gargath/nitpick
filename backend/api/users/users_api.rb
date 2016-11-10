# frozen_string_literal: true
require 'grape'
require 'bcrypt'
require 'securerandom'
require 'resque'
require_relative '../log_helper.rb'
require_relative '../auth_helper.rb'
require_relative '../../model/user_validation.rb'
require_relative '../../model/user.rb'
require_relative '../../jobs/verification_job.rb'

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
      u = declared(params)[:user]
      if User.exists?(username: u[:username])
        error!({ 'error' => "User '#{u[:username]}' already exists" }, 409)
      end
      new_user = Nitpick::UsersAPI.create_user(u)
      begin
        new_user.save
      rescue ActiveRecordError => e
        Rollbar.error('ActiveRecordError while trying to save new user',
                      e,
                      username: u[:username], request_id: env['request_id'])
        error!({ 'error' => "Failed to persist new user #{new_user.username} (#{new_user.id})" },
               500)
      end
      logger.info format("New user #{new_user.username} created.")
      unless Resque.enqueue(VerificationEmailJob,
                            new_user.id,
                            new_user.username,
                            new_user.email,
                            new_user.user_validation.token)
        logger.error format("Failed to enqueue email verification job for #{new_user.username}!")
        Rollbar.error('Resque.enqueue returned false on EmailVerificationJob',
                      new_user.username, new_user.email)
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

    get ':id' do
      authenticate!
      begin
        user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        error!({ 'error' => 'No such user' }, 404)
      end
      logger.info format("Request for user #{params[:id]}")
      user
    end

    params do
      requires :validation_token, type: String
    end
    put ':id/validationtoken' do
      logger.debug(format("Validating user #{params[:id]}"))
      begin
        user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        logger.debug(format("User #{params[:id]} not found"))
        error!({ 'error' => 'No such user' }, 404)
      end
      if user.user_status != 'NEW'
        logger.debug(format("User #{params[:id]} is not new"))
        error!({ 'error' => "User #{p} already verified" }, 409)
      elsif user.user_validation.token != params[:validation_token]
        logger.debug(format("Token is invalid"))
        error!({ 'error' => 'Invalid validation token' }, 403)
      end
      user.user_validation.completed_at = Time.now
      logger.debug(
        format("User #{user.username} now has validation completed_at set to \
          #{user.user_validation.completed_at}")
      )
      user.status = 1
      user.save
      status 200
      user
    end

    def self.create_user(u)
      # TODO: Check if email already exists and reject if so
      new_user = User.create(username: u[:username],
                             email: u[:email],
                             password: u[:password],
                             status: 0)
      validation = UserValidation.create(created_at: Time.now,
                                         token: JWT.encode({ username: new_user.username,
                                                             user_id: new_user.id,
                                                             token: SecureRandom.base64(32) },
                                                           nil,
                                                           'none'))
      new_user.user_validation = validation
      new_user
    end
  end
end
