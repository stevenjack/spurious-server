require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
ENV['RACK_ENV'] = 'test'

task :default => :spec
