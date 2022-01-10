require_relative 'lib/aspire_budget/version'

Gem::Specification.new do |spec|
  spec.name          = "aspire_budget"
  spec.version       = AspireBudget::VERSION
  spec.authors       = ["Spencer Fitzgerald"]
  spec.email         = ["spencerfitz0196@gmail.com"]

  spec.summary       = %q{Write a longer description or delete this line.}
  spec.description   = %q{Write a longer description or delete this line.}
  spec.homepage      = ""
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = ''
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  # spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
  #   `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  # end
  spec.files = Dir['lib/**/*.rb'] + Dir['bin/*']
  spec.files += Dir['[A-Z]*']
  spec.files.reject! { |fn| fn.include? "CVS" }

  spec.bindir        = "exe"
  spec.executables   = ["aspire"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "byebug"

  spec.add_dependency "google_drive"
  spec.add_dependency "thor"
end
