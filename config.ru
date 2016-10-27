# frozen_string_literal: true
#\ -s puma
require 'rack/cors'
require 'rollbar'
require './backend/api/nitpick_api.rb'
require './backend/middleware/rollbar_interceptor.rb'
require './backend/middleware/jwt_validator.rb'
require './backend/middleware/request_id_generator.rb'
require './backend/middleware/app_logger.rb'

module Rack
  # Monkey patch to make Rack Logger STFU
  class CommonLogger
    def call(env)
      @app.call(env)
    end
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
  use RequestIdGenerator
  use JWTValidator
  run Nitpick::API
end

map '/web' do
  use Rack::Static, urls: ['/'], root: 'frontend/app', index: 'index.html'
end

run ->(_env) { [302, { 'Location' => '/web/' }, []] }
