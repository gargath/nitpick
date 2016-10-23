# frozen_string_literal: true
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
