require 'grape'

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

end