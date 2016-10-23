#\ -s puma
require 'rack/cors'
require './backend/nitpick_api.rb'

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
