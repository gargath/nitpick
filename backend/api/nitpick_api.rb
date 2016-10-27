# frozen_string_literal: true
require 'grape'
require_relative './status/status_api.rb'
require_relative './authorization/auth_api.rb'
require_relative './log_helper.rb'

module Nitpick
  # The main API class
  class API < Grape::API
    mount StatusAPI
    mount AuthAPI

    content_type :json, 'application/json'
    version 'v1', using: :path
    default_format :json

    helpers LogHelper

    get :users do
      [
        { id: 0, firstname: 'John', lastname: 'Doe', username: 'jdoe' },
        { id: 1, firstname: 'Jane', lastname: 'Doe', username: 'jdoe' }
      ]
    end
  end
end
