# frozen_string_literal: true
class VerificationEmailJob
  @queue = :verify_user

  def self.perform(username, email, token)
    Resque.logger = Logger.new(STDOUT)
    Resque.logger.level = Logger::INFO
    Resque.logger.info "Doing work for #{username} <#{email}> with token #{token}"
  end
end