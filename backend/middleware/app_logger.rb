# frozen_string_literal: true

# Middleware for injecting a common logger into the request env
class AppLogger
  def initialize(app)
    @app = app
    @logger = Logger.new(STDOUT)
    @logger.level = case ENV['RACK_env']
                    when 'production'
                      Logger::INFO
                    else
                      Logger::DEBUG
                    end
    @logger.formatter = proc do |severity, datetime, _progname, msg|
      date_format = datetime.strftime('%Y-%m-%d %H:%M:%S')
      if severity == 'INFO' || severity == 'WARN'
        "[#{date_format}] #{severity}  #{msg}\n"
      else
        "[#{date_format}] #{severity} #{msg}\n"
      end
    end
    @logger.info("Log Injector initialized with log level #{@logger.level}")
  end

  def call(env)
    env['logger'] = @logger
    @app.call(env)
  end
end
