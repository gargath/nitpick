# frozen_string_literal: true
require 'rspec'
require 'jwt'

describe JWTValidator do
  include Rack::Test::Methods

  def app
    Rack::Builder.new do
      use AppLogger
      use JWTValidator
      run ->(env) { [200, {}, env['nitpick_token'].to_json] }
    end.to_app
  end

  before do
    @secret = JWTValidator::JWT_SECRET
  end

  context 'when using a malformed token'
  it 'should respond with 401 and correct Header' do
    header 'Authorization', 'invalid'
    get '/'
    expect(last_response.status).to eq(401)
    expect(last_response.headers['X-JWT-ERROR']).to eq('Malformed Token')
  end

  context 'when using an invalid token'
  it 'should respond with 401 and correct Header' do
    token = JWT.encode(
      { username: 'username', password: 'password' },
      'somesecretthatsnothours',
      'HS256'
    )
    header 'Authorization', token
    get '/'
    expect(last_response.status).to eq(401)
    expect(last_response.headers['X-JWT-ERROR']).to eq('Invalid Signature')
  end

  context 'when using a valid token'
  it 'should add the token to the env' do
    payload = { 'username' => 'username', 'password' => 'password' }
    token = JWT.encode(
      payload,
      @secret,
      'HS256'
    )
    header 'Authorization', token
    get '/'
    expect(last_response.status).to eq(200)
    expect(JSON.parse(last_response.body)).to eq(payload)
    expect(last_response.headers['X-JWT-ERROR']).to be_nil
  end
end
