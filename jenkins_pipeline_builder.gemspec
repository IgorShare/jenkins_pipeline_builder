# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jenkins_pipeline_builder/version'

Gem::Specification.new do |spec|
  spec.name          = 'jenkins_pipeline_builder'
  spec.version       = JenkinsPipelineBuilder::VERSION
  spec.authors       = ['Igor Moochnick']
  spec.email         = %w(igor.moochnick@gmail.com)
  spec.description   = %q{This is a simple and easy-to-use Jenkins Pipeline generator with features focused on
automating Job & Pipeline creation from the YAML files checked-in with your application source code}
  spec.summary       = %q{This gem is will boostrap your Jenkins pipelines}
  spec.homepage      = 'https://github.com/IgorShare/jenkins_pipeline_builder'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'nokogiri', '~> 1.5.0'
  spec.add_dependency 'jenkins_api_client', '~> 0.14.1'
  spec.add_dependency 'thor', '>= 0.18.0'
  spec.add_dependency 'activesupport'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'bump'
  spec.add_development_dependency 'gem-release'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-rcov'
  spec.add_development_dependency 'kwalify'
  spec.add_development_dependency 'equivalent-xml'
  spec.add_development_dependency 'yard-thor'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'webmock'
end
