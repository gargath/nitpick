# frozen_string_literal: true

# Helper methods for dealing with authorization
module AuthHelper

  def authenticate!
    error! 'Requires Login', 403 unless current_user
  end

  def current_user
    env['nitpick_token']
  end

end
