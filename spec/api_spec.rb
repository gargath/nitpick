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
end
