# encoding: utf-8
require File.expand_path('../lib/iprofiler/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_dependency 'hashie', '~> 2.0.2'
  gem.add_dependency 'multi_json', '~> 1.7.7'
  gem.add_development_dependency 'json', '~> 1.7.7'
  gem.add_development_dependency 'rake', '~> 10.0.3'
  gem.add_development_dependency 'rdoc', '~> 4.0.0'
  gem.add_development_dependency 'rspec', '~> 2.13.0'
  gem.add_development_dependency 'simplecov', '~> 0.7.1'
  gem.add_development_dependency 'vcr', '~> 2.4.0'
  gem.add_development_dependency 'webmock', '~> 1.11.0'
  gem.authors = ["Harish Shetty"]
  gem.description = %q{Ruby wrapper for the iProfile API}
  gem.email = ['kandada.boggu@gmail.com']
  gem.files = `git ls-files`.split("\n")
  gem.homepage = 'http://github.com/kandadaboggu/iprofiler'
  gem.name = 'iprofiler'
  gem.require_paths = ['lib']
  gem.summary = gem.description
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.version = Iprofiler::VERSION::STRING
end
