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
  spec.required_ruby_version = '>= 2.6.8'

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/changelog"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 5"

  spec.add_development_dependency "standard", "~> 1.1.6"
  spec.add_development_dependency "yard", "~> 0.9.26"
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "awesome_print", "~> 1.9.2"
end
