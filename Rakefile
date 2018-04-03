begin
  require 'rspec/core/rake_task'
rescue LoadError
  raise
end

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :console do
  require "bundler/setup"
  require "irb"

  lib_path = File.join(Dir.pwd, 'lib')
  $LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)
  require 'hex_arch_examples'

  ARGV.clear

  IRB.start
end
