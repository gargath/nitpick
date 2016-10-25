# frozen_string_literal: true
require 'rollbar/rake_tasks'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

desc 'Run all Tests'
task default: [:rubocop, :spec, :karma]

desc 'Run RSpec Tests'
task test: :spec

desc 'Run Rubocop on Ruby Codebase'
task :rubocop do
  sh 'rubocop'
end

desc 'Run Karma Tests on JS Codebase'
task :karma do
  sh 'npm run test-single-run'
end

task :environment do
  Rollbar.configure do |config|
    config.access_token = '8e4c44565fd5499597a641000a3181d2'
  end
end
