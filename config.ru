# frozen_string_literal: true
#\ -s puma
require 'active_record'
require 'redis'
require 'erb'
require 'resque'
require 'rack/cors'
require 'rollbar'
require './backend/api/nitpick_api.rb'
require './backend/middleware/rollbar_interceptor.rb'
require './backend/middleware/jwt_validator.rb'
require './backend/middleware/request_id_generator.rb'
require './backend/middleware/app_logger.rb'

puts
puts "WARNING: Installing bcrypt gem's native extensions is currently broken on Windows.
If running on Windows, please quit now and run devkitvars.bar, \
then make, make install in \\bcrypt-3.1.7-x86-mingw32\\ext\\mri"
puts

module Rack
  # Monkey patch to make Rack Logger STFU
  class CommonLogger
    def call(env)
      @app.call(env)
    end
  end
end

class TestJob
 @queue = :test_queue

 def self.perform
  puts "Job done!"
 end
end


Rollbar.configure do |config|
  config.access_token = '8e4c44565fd5499597a641000a3181d2'
  config.enabled = false unless ENV['RACK_ENV'] == 'production'
end
use RollbarInterceptor

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :get
  end
end

use AppLogger

map '/api' do
<<<<<<< e48fd85c75bb2f365b3836f615f7005e48254ed5
  environment = ENV['ENV'] || 'dev'
  db_config = YAML.load(ERB.new(File.read('./config/database.yml')).result)
  ActiveRecord::Base.establish_connection db_config[environment]
  Resque.redis = Redis.new(url: ENV['REDIS_URL'], thread_safe: true)
  use ActiveRecord::ConnectionAdapters::ConnectionManagement
=======
  Resque.redis = Redis.new(host: 'localhost', port: 6379, thread_safe: true)
>>>>>>> Add resque poc and test
  use RequestIdGenerator
  use JWTValidator
  run Nitpick::API
end

map '/web' do
  use Rack::Static, urls: ['/'], root: 'frontend/app', index: 'index.html'
end

run ->(_env) { [302, { 'Location' => '/web/' }, []] }
