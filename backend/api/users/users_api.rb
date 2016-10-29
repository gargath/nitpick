# frozen_string_literal: true
require 'grape'
require_relative '../log_helper'

module Nitpick
  # API for querying system status
  class UsersAPI < Grape::API
    prefix 'users'
    content_type :json, 'application/json'
    version 'v1', using: :path
    default_format :json

    helpers LogHelper

    get '/' do
      response = []
      User.all.each do |user|
        response << { 'id': user.id, 'username': user.name }
      end
      response
    end
  end
end
