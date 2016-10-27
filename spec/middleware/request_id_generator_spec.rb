# frozen_string_literal: true
require 'rspec'

describe RequestIdGenerator do
  include Rack::Test::Methods

  def app
    Rack::Builder.new do
      use AppLogger
      use RequestIdGenerator
      run ->(env) { [200, {}, env['request_id']] }
    end.to_app
  end

  it 'should add a request id header to any response' do
    get '/'
    expect(last_response.headers['X-Request-Id']).not_to be_nil
  end

  it 'should add the id to the env' do
    get '/'
    expect(last_response.body).to eq(last_response.headers['X-Request-Id'])
  end

  it 'should generate different ids for subsequent requests' do
    get '/'
    h1 = last_response.headers['X-Request-Id']
    expect(h1).not_to be_nil
    get '/test'
    h2 = last_response.headers['X-Request-Id']
    expect(h2).not_to be_nil
    expect(h1).not_to eq(h2)
  end
end
