# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'queru_btce/version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'queru_btce'
  spec.version       = QueruBtce::VERSION
  spec.authors       = ['Queru AKA Jorge Fuertes']
  spec.email         = ['jorge@jorgefuertes.com']
  spec.summary       = 'KISS BTC-E API Access from Ruby'
  spec.description   = 'Supports all API methods and currency pairs.'
  spec.homepage      = 'https://github.com/jorgefuertes/queru-btce'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'json'
  spec.add_dependency 'rubysl-ostruct'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'shoulda'
end
