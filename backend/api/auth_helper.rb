# frozen_string_literal: true

# Helper methods for dealing with authorization
module AuthHelper
  def authenticate!
    return if current_user
    logger.info(
      format("Denying anonymous access to \
        [#{env['REQUEST_METHOD']} #{env['REQUEST_PATH']}] from #{env['REMOTE_ADDR']}")
    )
    error!({ 'error' => 'Requires Login' }, 403)
  end

  def current_user
    env['nitpick_token']
  end
end
