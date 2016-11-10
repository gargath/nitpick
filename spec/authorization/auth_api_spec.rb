# frozen_string_literal: true
require 'spec_helper'

describe Nitpick::AuthAPI do
  include Rack::Test::Methods

  def app
    Rack::Builder.new do
      use ActiveRecord::ConnectionAdapters::ConnectionManagement
      use AppLogger
      use JWTValidator
      run Nitpick::API
    end.to_app
  end

  before do
    environment = 'test'
    db_config = YAML.load(File.read('./config/database.yml'))
    ActiveRecord::Base.establish_connection db_config[environment]
    if ActiveRecord::Migrator.needs_migration?
      ActiveRecord::Migrator.migrate('./db/migrate')
    end
    user = User.create
    user.username = 'admin'
    user.password = 'pass'
    user.status = 1
    user.save
  end

  after do
    ActiveRecord::Base.remove_connection
    File.delete('./db/test.sqlite3')
  end

  context 'when missing parameter' do
    it 'responds with 400' do
      data = { 'username': 'user' }
      post '/auth/v1/login', data
      expect(last_response.status).to eq(400)
    end
  end

  context 'when using invalid credentials' do
    it 'responds with 403' do
      data = { 'username': 'user', 'password': 'invalid' }
      post '/auth/v1/login', data
      expect(last_response.status).to eq(403)
    end
  end

  context 'when using an unconfirmed account' do
    it 'responds 403' do
      post '/users/v1/', 'user' => { 'username' => 'newuser',
                                     'password' => 'pass',
                                     'email' => 'email@example.com' }
      expect(last_response.status).to eq(201)
      data = { 'username': 'newuser', 'password': 'pass' }
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
