# frozen_string_literal: true

# Helper method for retreiving the common logger
module LogHelper
  def logger
    env['logger']
  end

  def format(message)
    env['request_id'] ? "[#{env['request_id']}] - #{message}" : "[] - #{message}"
  end
end
