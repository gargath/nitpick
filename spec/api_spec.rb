require 'spec_helper'

describe NitpickAPI do
  include Rack::Test::Methods

  def app
    NitpickAPI
  end

  context 'GET /v1/hello' do
    it 'says hello to the world' do
      get '/v1/hello'
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)['hello']).to eq 'world'
    end
  end

  context 'GET /v1/users' do
    it 'returns many users' do
      get '/v1/users'
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body).count).to be > 0
    end
  end
end
