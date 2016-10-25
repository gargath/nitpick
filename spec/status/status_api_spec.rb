# frozen_string_literal: true
require 'spec_helper'

describe Nitpick::StatusAPI do
  include Rack::Test::Methods

  def app
    Nitpick::StatusAPI
  end

  context 'GET /status/v1/ping' do
    it 'says responds pong' do
      get '/status/v1/ping'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq '"pong"'
    end
  end

  context 'GET /status/v1/status' do
    it 'responds with operational' do
      get '/status/v1/status'
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)['status']).to eq 'operational'
    end
  end
end
