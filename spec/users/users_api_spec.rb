# frozen_string_literal: true
require 'active_record'
require 'spec_helper'

describe Nitpick::UsersAPI do
  include Rack::Test::Methods

  def app
    Rack::Builder.new do
      use ActiveRecord::ConnectionAdapters::ConnectionManagement
      use AppLogger
      run Nitpick::UsersAPI
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
    user.name = 'testuser'
    user.save
  end

  after do
    ActiveRecord::Base.remove_connection
    File.delete('./db/test.sqlite3')
  end

  context 'get should return all users' do
    it 'returns the test user' do
      get '/users/v1/'
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to eq([{ 'id' => 1, 'username' => 'testuser' }])
    end
  end
end
