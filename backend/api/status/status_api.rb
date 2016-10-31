# frozen_string_literal: true
require 'grape'
require_relative '../log_helper.rb'
require_relative '../auth_helper.rb'
# require 'resque'

module Nitpick
  # API for querying system status
  class StatusAPI < Grape::API
    prefix 'status'
    content_type :json, 'application/json'
    version 'v1', using: :path
    default_format :json

    helpers LogHelper
    helpers AuthHelper

    get :status do
      authenticate!
      response = { status: 'operational' }
      e = []
      ENV.each do |name, value|
        e << { name => value }
      end
      response['environment'] = e
      e = []
      env.each do |name, value|
        e << { name => value.to_s }
      end
      response['rack_environment'] = e
      response
      # logger.info('enqueueing')
      # enqueued = Resque.enqueue(TestJob)
      # logger.info(enqueued ? 'true' : 'false')
      # logger.info(Resque.info)
      # { status: 'operational' }
    end

    get :ping do
      logger.info(format('Pingpong'))
      'pong'
    end
  end
end
