# frozen_string_literal: true
require 'spec_helper'

describe Nitpick::API do
  include Rack::Test::Methods

  def app
    Rack::Builder.new do
      use AppLogger
      run Nitpick::API
    end.to_app
  end

  context 'GET /v1/users' do
    it 'returns many users' do
      get '/v1/users'
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body).count).to be > 0
    end
  end
end
