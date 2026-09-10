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
  spec.required_ruby_version = ">= 3.2", "< 3.5"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir["{app,config,db,lib}/**/*", "CHANGELOG.md", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 7"

  spec.add_development_dependency "standard", "~> 1.56"
  spec.add_development_dependency "yard", "~> 0.9.37"
  spec.add_development_dependency "rspec", "~> 3.13"
  spec.add_development_dependency "awesome_print", "~> 1.9.2"
end
