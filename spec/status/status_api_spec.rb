# frozen_string_literal: true
require 'spec_helper'

describe Nitpick::StatusAPI do
  include Rack::Test::Methods

  def app
    Rack::Builder.new do
      use AppLogger
      use JWTValidator
      run Nitpick::API
    end.to_app
  end

  context 'when pinged' do
    it 'says responds pong' do
      get '/status/v1/ping'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq '"pong"'
    end
  end

  context 'when asked for status' do
    it 'responds with 403 to anonymous requests' do
      get '/status/v1/status'
      expect(last_response.status).to eq(403)
    end

    it 'responds with stuff when authenticated' do
      post '/auth/v1/login', { 'username' => 'admin', 'password' => 'pass' }
      token = JSON.parse(last_response.body)['authtoken']
      header 'Authorization', token
      get '/status/v1/status'
      expect(last_response.status).to eq(200)
      response = JSON.parse(last_response.body)
      expect(response['status']).to eq 'operational'
      expect(response['environment'].length).to be > 0
      expect(response['rack_environment'].length).to be > 0
    end
  end
end
