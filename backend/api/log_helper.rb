# frozen_string_literal: true

# Helper method for retreiving the common logger
module LogHelper
  def logger
    env['logger']
  end
end
