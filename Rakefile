begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

task default: [:rubocop, :spec]
task test:    :spec
task :rubocop do
  sh 'rubocop'
end
