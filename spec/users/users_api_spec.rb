# frozen_string_literal: true
require 'active_record'
require 'fakeredis'
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
    user.username = 'admin'
    user.password = 'pass'
    user.status = 1
    user.save
    @user_id = user.id
    Resque.redis = Redis.new
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
    it 'returns the admin user when authenticated' do
      post '/auth/v1/login', 'username' => 'admin', 'password' => 'pass'
      token = JSON.parse(last_response.body)['authtoken']
      header 'Authorization', token
      get '/users/v1/'
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq([{ 'id' => 1, 'username' => 'admin' }])
    end
  end

  context 'when asked for a specific user' do
    it 'responds with the user details in case of valid id' do
      post '/auth/v1/login', 'username' => 'admin', 'password' => 'pass'
      token = JSON.parse(last_response.body)['authtoken']
      header 'Authorization', token
      get "/users/v1/#{@user_id}"
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)['username']).to eq('admin')
    end
    it 'responds 404 if invalid id' do
      post '/auth/v1/login', 'username' => 'admin', 'password' => 'pass'
      token = JSON.parse(last_response.body)['authtoken']
      header 'Authorization', token
      get '/users/v1/999'
      expect(last_response.status).to eq(404)
    end
    it 'refuses access without login' do
      get "/users/v1/#{@user_id}"
      expect(last_response.status).to eq(403)
    end
  end

  context 'when adding a user' do
    it 'responds 400 if a parameter is missing' do
      post '/users/v1/', 'username' => 'newuser', 'password' => 'pass'
      expect(last_response.status).to be(400)
    end
    it 'creates a new user entry in the database and enqueues a verification email' do
      post '/users/v1/', 'user' => { 'username' => 'newuser',
                                     'password' => 'pass',
                                     'email' => 'email@example.com' }
      expect(last_response.status).to eq(201)
      resp = JSON.parse(last_response.body)
      expect(resp['id']).not_to be_nil
      expect(User.exists?(resp['id'])).to be_truthy
      expect(Resque.peek('verify_user', 0, 5).length).not_to eq(0)
    end
    it 'return 409 if a username is already taken' do
      post '/users/v1/', 'user' => { 'username' => 'newuser',
                                     'password' => 'pass',
                                     'email' => 'email@example.com' }
      post '/users/v1/', 'user' => { 'username' => 'newuser',
                                     'password' => 'pass',
                                     'email' => 'email@example.com' }
      expect(last_response.status).to eq(409)
    end
  end

  context 'when validating a user' do
    before(:each) do
      post '/users/v1/', 'user' => { 'username' => 'newuser',
                                     'password' => 'pass',
                                     'email' => 'email@example.com' }
      @new_id = JSON.parse(last_response.body)['id']
      user = User.find(@new_id)
      @token = user.user_validation.token
    end

    it 'responds 400 if a parameter is missing' do
      put "/users/v1/#{@new_id}/validationtoken", 'nonsense' => 'stuff'
      expect(last_response.status).to be(400)
    end
    it 'responds with 404 if the user does not exist' do
      put "/users/v1/#{@new_id + 1000}/validationtoken", 'validation_token' => 'stuff'
      puts last_response.body
      expect(last_response.status).to be(404)
    end
    it 'responds with 403 if the token is invalid' do
      put "/users/v1/#{@new_id}/validationtoken", 'validation_token' => 'stuff'
      expect(last_response.status).to be(403)
    end
    it 'updates the user and validation status if everything is correct' do
      put "/users/v1/#{@new_id}/validationtoken", 'validation_token' => @token
      expect(last_response.status).to be(200)
      resp = JSON.parse(last_response.body)
      expect(resp['status']).to eq 'VERIFIED'
      user = User.find(@new_id)
      expect(user.user_validation.completed_at).not_to be_nil
    end
    it 'responds with 409 if the user is already verified' do
      put "/users/v1/#{@new_id}/validationtoken", 'validation_token' => @token
      put "/users/v1/#{@new_id}/validationtoken", 'validation_token' => @token
      expect(last_response.status).to be(409)
    end
  end
end
