# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'locket/version'

Gem::Specification.new do |spec|
  spec.name          = 'locket'
  spec.version       = Locket::VERSION
  spec.authors       = ['Isaac Azuelos']
  spec.email         = ['isaac@azuelos.ca']

  spec.summary       = 'A command line password/snippet manager.'
  spec.homepage      = 'https://github.com/isaacazuelos/locket'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host' to allow pushing to a single host or delete this
  # section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = ['locket']

  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.46.0'
  spec.add_development_dependency 'fakefs', '~> 0.10.1'
  spec.add_development_dependency 'guard-rspec', '~> 4.7', '>= 4.7.3'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-doc', '>= 0.6.0'
  spec.add_development_dependency 'method_source', '>= 0.8.2'
end
