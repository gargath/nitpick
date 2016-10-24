# frozen_string_literal: true
#\ -s puma
require 'rack/cors'
require 'rollbar'
require './backend/nitpick_api.rb'
require './backend/rollbar_interceptor.rb'

puts ENV['RACK_ENV']

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

map '/api' do
  run NitpickAPI
end

map '/web' do
  use Rack::Static, urls: ['/'], root: 'frontend/app', index: 'index.html'
end

headers = { 'Content-Type' => 'text/html', 'Content-Length' => '9' }
run ->(_env) { [404, headers, ['Not Found']] }
