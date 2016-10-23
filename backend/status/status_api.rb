# frozen_string_literal: true
require 'grape'

# API for querying system status
class StatusAPI < Grape::API
  prefix 'status'
  content_type :json, 'application/json'
  version 'v1', using: :path
  default_format :json

  helpers do
    def logger
      NitpickAPI.logger
    end
  end

  get :status do
    { status: 'operational' }
  end

  get :ping do
    'pong'
  end
end
