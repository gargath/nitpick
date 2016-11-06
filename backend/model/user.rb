# frozen_string_literal: true
require 'active_record'
require 'bcrypt'
require_relative './user_validation.rb'

# ActiveRecord class representing a user of the system
class User < ActiveRecord::Base
  include BCrypt

  has_one :user_validation, autosave: true

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def user_status
    case status
    when 0
      'NEW'
    when 1
      'VERIFIED'
    else
      'UNKNOWN'
    end
  end

  def to_json
    { username: username, email: email, status: user_status }.to_json
  end
end
