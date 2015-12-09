require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'mutant'

RuboCop::RakeTask.new(:rubocop)
RSpec::Core::RakeTask.new(:spec)

desc 'Run mutation tests using mutant'
task :mutant do
  ENV['SKIP_COVERAGE'] = 'true'
  result = Mutant::CLI.run(%w( -Ilib -rlita/virus_total --use rspec Lita::Handlers::VirusTotal))
  fail unless result == Mutant::CLI::EXIT_SUCCESS
end

task default: [:spec, :rubocop, :mutant]
