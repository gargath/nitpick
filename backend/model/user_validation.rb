# frozen_string_literal: true
require 'active_record'
require_relative './user.rb'

# Class representing a user account validation
class UserValidation < ActiveRecord::Base
  belongs_to :user
end