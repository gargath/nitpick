# frozen_string_literal: true
# Test job
class TestJob
  @queue = :test_queue

  def self.perform
    Resque.logger = Logger.new(STDOUT)
    Resque.logger.level = Logger::DEBUG
    Resque.logger.info 'Job done!'
  end
end
