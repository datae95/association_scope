# frozen_string_literal: true

require_relative "lib/association_scope/version"

Gem::Specification.new do |spec|
  spec.name = "association_scope"
  spec.version = AssociationScope::VERSION
  spec.authors = ["datae"]
  spec.email = ["accounts@datae.de"]
  spec.homepage = "https://github.com/datae95/association_scope"
  spec.summary = "Chain Active Record associations from relation scopes."
  spec.description = "AssociationScope lets Active Record relations expose associations as chainable scopes."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2", "< 4.1"

  spec.metadata["homepage_uri"] = "#{spec.homepage}#readme"
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir["{app,config,db,lib}/**/*", "CHANGELOG.md", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 7.1"

  spec.add_development_dependency "standard", "~> 1.56"
  spec.add_development_dependency "yard", "~> 0.9.37"
  spec.add_development_dependency "rspec", "~> 3.13"
  spec.add_development_dependency "awesome_print", "~> 1.9.2"
  spec.add_development_dependency "bundler-audit", "~> 0.9"
end
