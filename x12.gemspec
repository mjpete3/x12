# -*- encoding: utf-8 -*-
require File.expand_path('../lib/x12/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "X12"
  gem.version       = X12::VERSION
  gem.authors       = ["App Design, Inc.", "Sean Walberg", "Marty Petersen"]
  gem.email         = ["info@appdesign.com", "sean@ertw.com", "themooseman@comcast.net"]
  gem.description   = %q{A gem to handle parsing and generation of ANSI X12 documents. Forked from the project at http://www.appdesign.com/x12parser/}
  gem.summary       = %q{A gem to handle parsing and generation of ANSI X12 documents}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
