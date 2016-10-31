# frozen_string_literal: true
# Async job for sending verification emails
class VerificationEmailJob
  @queue = :email_job

  def self.perform(uername, email)
    Resque.logger = Logger.new(STDOUT)
    Resque.logger.level = Logger::DEBUG
    Resque.logger.info "Doing work for #{username} at #{email}!"
  end

end