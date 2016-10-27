# frozen_string_literal: true
require 'spec_helper'

describe Nitpick::AuthAPI do
  include Rack::Test::Methods

  def app
    Rack::Builder.new do
      use AppLogger
      run Nitpick::AuthAPI
    end.to_app
  end

  context 'when missing parameter' do
    it 'responds with 422' do
      data = { 'username': 'user' }
      post '/auth/v1/login', data
      expect(last_response.status).to eq(422)
    end
  end

  context 'when using invalid credentials' do
    it 'responds with 403' do
      data = { 'username': 'user', 'password': 'invalid' }
      post '/auth/v1/login', data
      expect(last_response.status).to eq(403)
    end
  end

  context 'when using valid credentials' do
    it 'responds with an auth token' do
      data = { 'username': 'admin', 'password': 'pass' }
      post '/auth/v1/login', data
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)['authtoken']).to be
    end
  end
  context 'when using get' do
    it 'responds with 405 Method Not Allowed' do
      get '/auth/v1/login'
      expect(last_response.status).to eq(405)
    end
  end
end
