# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rack-auth-ip/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Keiji, Yoshimi"]
  gem.email         = ["walf443@gmail.com"]
  gem.description   = %q{rack middleware for restrict ip}
  gem.summary       = %q{rack middleware for restrict ip}
  gem.homepage      = "http://github.com/walf443/rack-auth-ip"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/.*_spec.rb})
  gem.name          = "rack-auth-ip"
  gem.require_paths = ["lib"]
  gem.version       = Rack::Auth::Ip::VERSION
end
