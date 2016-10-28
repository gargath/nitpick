# frozen_string_literal: true
require 'grape'
require_relative '../log_helper'
module Nitpick
  # API for querying system status
  class StatusAPI < Grape::API
    prefix 'status'
    content_type :json, 'application/json'
    version 'v1', using: :path
    default_format :json

    helpers LogHelper

    get :status do
      { status: 'operational' }
    end

    get :ping do
      logger.info(format('Pingpong'))
      'pong'
    end
  end
end
