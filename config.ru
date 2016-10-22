#\ -s puma
require 'rack/cors'
require './backend/nitpick_api.rb'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :get
  end
end

run NitpickAPI
