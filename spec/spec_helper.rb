# frozen_string_literal: true
require 'simplecov'
require 'rack/test'
SimpleCov.start
require './backend/api/nitpick_api.rb'
require './backend/api/status/status_api.rb'
require './backend/api/authorization/auth_api.rb'
require './backend/middleware/jwt_validator.rb'
