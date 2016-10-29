# frozen_string_literal: true
require 'resque/tasks'
require 'erb'
require 'bundler/setup'
require 'active_record'
# Remember to require here the file containing any Resque classes so that workers can find them.

include ActiveRecord::Tasks

db_dir = File.expand_path('../db', __FILE__)
config_dir = File.expand_path('../config', __FILE__)

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

DatabaseTasks.env = ENV['ENV'] || 'dev'
DatabaseTasks.db_dir = db_dir
DatabaseTasks.database_configuration = YAML.load(ERB.new(File.read(File.join(config_dir, 'database.yml'))).result)
DatabaseTasks.migrations_paths = File.join(db_dir, 'migrate')

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
  ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
  ActiveRecord::Base.establish_connection DatabaseTasks.env.to_sym
end

load 'active_record/railties/databases.rake'
