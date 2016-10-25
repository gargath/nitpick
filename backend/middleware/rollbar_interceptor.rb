# frozen_string_literal: true
require 'rollbar'

# Middleware for reporting of uncaught exceptions to Rollbar
class RollbarInterceptor
  def initialize(app)
    log('INFO', 'Rollbar Interceptor initialized')
    log('INFO', 'Rollbar Reporting silenced') unless Rollbar.configuration['enabled']
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue Exception => e
    log('ERROR', e.message)
    e.backtrace.each { |line| log('ERROR', '  ' + line) }
    Rollbar.error('Uncaught Exception', e)
    response = Rack::Response.new('Internal Server Error', 500)
    response.finish
  end

  private

  def log(level, line)
    puts "[#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}] #{level} #{line}"
  end
end
