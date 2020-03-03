# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'version'

Gem::Specification.new do |spec|
  spec.name          = "varopago"
  spec.version       = Varopago::VERSION
  spec.authors       = ["Varopago","ronnie_bermejo"]
  spec.email         =  ["hola@varopago.mx"]
  spec.description   = %q{ruby client for Varopago API services (version 2.0.0)}
  spec.summary       = %q{ruby api for varopago resources}
  spec.homepage      = "http://varopago.mx/"
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ['lib','lib/varopago','varopago','.']

  spec.add_runtime_dependency 'rest-client'  , '~>2.0'
  spec.add_runtime_dependency 'json', '>= 1.8'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'json_spec'
  spec.post_install_message = 'Thanks for installing varopago. Enjoy !'

end
