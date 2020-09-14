require_relative 'lib/peperusha/version'

Gem::Specification.new do |spec|
  spec.name          = "peperusha"
  spec.version       = Peperusha::VERSION
  spec.authors       = ["Sylvance Kerandi"]
  spec.email         = ["peperusha.kakitu@gmail.com"]

  spec.summary       = %q{Mpesa Client with better error handling and edge case protection.}
  spec.description   = %q{Peperusha use the power of ruby interactors to bring in better error handling and edge case scenarios for easier debugging.}
  spec.homepage      = "https://github.com/sylvance/peperusha"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sylvance/peperusha"
  spec.metadata["changelog_uri"] = "https://github.com/sylvance/peperusha"

  # dependencies
  spec.add_dependency "active_support/core_ext/module"
  spec.add_dependency "faraday"
  spec.add_dependency "interactor"
  spec.add_dependency "json"
  spec.add_dependency "logger"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
