# frozen_string_literal: true
require 'rollbar/rake_tasks'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

task default: [:rubocop, :spec, :karma]
task test:    :spec
task :rubocop do
  sh 'rubocop'
end
task :karma do
  sh 'npm run test-single-run'
end

task :environment do
  Rollbar.configure do |config|
    config.access_token = '8e4c44565fd5499597a641000a3181d2'
  end
end
