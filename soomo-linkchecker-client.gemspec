# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "soomo/link_checker/client/version"

Gem::Specification.new do |s|
  s.name        = "soomo-linkchecker-client"
  s.version     = Soomo::LinkChecker::Client::VERSION
  s.authors     = ["Matthew Bennink"]
  s.email       = ["matt@soomopublishing.com"]
  s.homepage    = "https://github.com/soomo/soomo-linkchecker-client"
  s.summary     = %q{Link Checker Client}
  s.description = %q{Link Checker Client}

  # s.rubyforge_project = "soomo-linkchecker-client"

  s.files         = [
    ".gitignore",
    "Gemfile",
    "README.md",
    "Rakefile",
    "lib/soomo-linkchecker-client.rb",
    "lib/soomo/link_checker/client/configuration.rb",
    "lib/soomo/link_checker/client/version.rb",
    "soomo-linkchecker-client.gemspec"
  ]
  # s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  # s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "amqp"
end
