# frozen_string_literal: true
require 'active_record'
require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  attr_accessor :name
  attr_accessor :email

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end
