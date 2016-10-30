# frozen_string_literal: true
require 'active_record'
require 'spec_helper'

describe Nitpick::UsersAPI do
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
    user.username = 'testuser'
    user.save
  end

  after do
    ActiveRecord::Base.remove_connection
    File.delete('./db/test.sqlite3')
  end

  context 'when asked for all users' do
    it 'responds 403 if anonymous' do
      get '/users/v1/'
      expect(last_response.status).to eq(403)
    end
    it 'returns the test user when authenticated' do
      post '/auth/v1/login', { 'username' => 'admin', 'password' => 'pass' }
      token = JSON.parse(last_response.body)['authtoken']
      header 'Authorization', token
      get '/users/v1/'
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq([{ 'id' => 1, 'username' => 'testuser' }])
    end
  end

  context 'when adding a user' do
    it 'responds 400 if a parameter is missing' do
      post '/users/v1/', { 'username' => 'newuser', 'password' => 'pass' }
      expect(last_response.status).to be(400)
    end
    it 'creates a new user entry in the database if data is valid' do
      post '/users/v1/', { 'user' => { 'username' => 'newuser', 'password' => 'pass', 'email' => 'email@example.com' } }
      expect(last_response.status).to eq(201)
      resp = JSON.parse(last_response.body)
      expect(resp['id']).not_to be_nil
      expect(User.exists?(resp['id'])).to be_truthy
    end
    it 'return 409 if a username is already taken' do
      post '/users/v1/', { 'user' => { 'username' => 'newuser', 'password' => 'pass', 'email' => 'email@example.com' } }
      post '/users/v1/', { 'user' => { 'username' => 'newuser', 'password' => 'pass', 'email' => 'email@example.com' } }
      expect(last_response.status).to eq(409)
    end
  end
end
