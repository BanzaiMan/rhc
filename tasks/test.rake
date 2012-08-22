require 'rspec/core/rake_task'
require 'cucumber'
require 'cucumber/rake/task'

desc "Run specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
<<<<<<< HEAD
=======
  t.rspec_opts = ['--color']
>>>>>>> Update RSpec to version 2.x
end

task :default => :spec
task :test => [:spec, :features]
