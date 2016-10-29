# frozen_string_literal: true
require 'grape'
require_relative './status/status_api.rb'
require_relative './authorization/auth_api.rb'
require_relative './users/users_api.rb'
require_relative './log_helper.rb'
require_relative '../model/user.rb'

module Nitpick
  # The main API class
  class API < Grape::API
    mount StatusAPI
    mount AuthAPI
    mount UsersAPI

    content_type :json, 'application/json'
    version 'v1', using: :path
    default_format :json

    helpers LogHelper
  end
end
