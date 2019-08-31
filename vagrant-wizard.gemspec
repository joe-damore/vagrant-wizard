
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "vagrant-wizard/version"

Gem::Specification.new do |spec|
  spec.name          = "vagrant-wizard"
  spec.version       = VagrantWizard::VERSION
  spec.authors       = ["Joe D'Amore"]
  spec.email         = ["joe@joedamore.me"]

  spec.summary       = "Interactive environment configuration"
  spec.description   = "Interactive configuration for Vagrant development environments"
  spec.homepage      = "https://github.com/joe-damore/vagrant-wizard"
  spec.license       = "MIT"

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  spec.files        = %x{git ls-files -z}.split("\0")
  spec.require_path = "lib"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10"
end
