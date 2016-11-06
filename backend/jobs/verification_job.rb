# frozen_string_literal: true
require 'uri'
require 'net/smtp'

# Resque job for emailing verification tokens
class VerificationEmailJob
  @queue = :verify_user

  def self.perform(user_id, username, email, token)
    Resque.logger = Logger.new(STDOUT)
    Resque.logger.level = Logger::INFO
    @logger = Resque.logger
    @logger.info 'Initializing Job'
    unless ENV['SMTP_URL']
      raise ArgumentError, 'SMTP_URL not set. Bailing out...'
    end

    message = <<MESSAGE_END
From: Nitpick <nitpick@example.com>
To: #{username} <#{email}>
Subject: Please verify your email

Please verify the email address used to sign up for Nitpick by using the token below.

#{token} / #{user_id}
MESSAGE_END

    mail_uri = URI.parse ENV['SMTP_URL']

    Net::SMTP.start(mail_uri.host, mail_uri.port) do |smtp|
      smtp.send_message message, 'nitpick@example.com', email
    end
    Resque.logger.info "Doing work for #{username} <#{email}> with token #{token} and user #{user_id}"
  end
end
