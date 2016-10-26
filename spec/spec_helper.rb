# frozen_string_literal: true
require 'simplecov'
require 'rack/test'
SimpleCov.start
require './backend/nitpick_api.rb'
require './backend/status/status_api.rb'
require './backend/authorization/auth_api.rb'
require './backend/middleware/jwt_validator.rb'
