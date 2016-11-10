# frozen_string_literal: true
require 'spec_helper'
require 'resque'
require 'fakeredis'

describe Nitpick::StatusAPI do
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

  context 'when pinged' do
    it 'says responds pong' do
      get '/status/v1/ping'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq '"pong"'
    end
  end

  context 'when asked for status' do
    before(:each) do
    end
    it 'responds with 403 to anonymous requests' do
      get '/status/v1/status'
      expect(last_response.status).to eq(403)
    end

    it 'responds with stuff when authenticated' do
      post '/auth/v1/login', 'username' => 'admin', 'password' => 'pass'
      token = JSON.parse(last_response.body)['authtoken']
      header 'Authorization', "Bearer #{token}"
      get '/status/v1/status'
      expect(last_response.status).to eq(200)
      response = JSON.parse(last_response.body)
      expect(response['status']).to eq 'operational'
      expect(response['environment'].length).to be > 0
      expect(response['rack_environment'].length).to be > 0
      # expect(JSON.parse(last_response.body)['status']).to eq 'operational'
      # expect(Resque.peek('test_queue', 0, 5).length).to eq(1)
    end
  end
end
