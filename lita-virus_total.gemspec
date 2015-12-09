lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lita/virus_total/version'

Gem::Specification.new do |spec|
  spec.name          = 'lita-virus_total'
  spec.version       = Lita::VirusTotal::VERSION
  spec.authors       = ["'Joseph Henrich'"]
  spec.email         = ['jhenrich@constantcontact.com']
  spec.description   = 'Use the virus total api to check file hashes and urls'
  spec.summary       = 'Use the virus total api to check file hashes and urls'
  spec.homepage      = 'http://github.com/constantcontact/lita-virus_total'
  spec.license       = 'BSD'
  spec.metadata      = { 'lita_plugin_type' => 'handler' }

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'lita', '>= 4.6'
  spec.add_runtime_dependency 'uirusu', '>= 1.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rspec', '>= 3.0.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'mutant'
  spec.add_development_dependency 'mutant-rspec'
end
