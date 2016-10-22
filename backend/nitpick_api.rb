require 'grape'

# The main API class
class NitpickAPI < Grape::API
  content_type :json, 'application/json'
  prefix 'api'
  version 'v1', using: :path
  default_format :json

  helpers do
    def logger
      NitpickAPI.logger
    end
  end

  get :hello do
    logger.info 'Hello called'
    { hello: 'world' }
  end

  get :users do
    logger.info 'Users called'
    [
      { id: 0, firstname: 'John', lastname: 'Doe', username: 'jdoe' },
      { id: 1, firstname: 'Jane', lastname: 'Doe', username: 'jdoe' }
    ]
  end
end
