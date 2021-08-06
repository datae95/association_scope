# frozen_string_literal: true

require_relative "lib/association_scope/version"

Gem::Specification.new do |spec|
  spec.name = "association_scope"
  spec.version = AssociationScope::VERSION
  spec.authors = ["datae"]
  spec.email = ["accounts@datae.de"]
  spec.homepage = "https://github.com/datae95/association_scope"
  spec.description = "AssociationScope adds useful scopes targeting Associations in ActiveRecord."
  spec.summary = spec.description
  spec.license = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/changelog"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 5"

  spec.add_development_dependency "standard", "~> 1.1.6"
  spec.add_development_dependency "yard", "~> 0.9.26"
  spec.add_development_dependency "rspec", "~> 3.10"

end
