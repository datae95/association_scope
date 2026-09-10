# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in association_scope.gemspec.
gemspec

# CI overrides this to exercise every Rails release supported by the gem.
gem "rails", ENV.fetch("RAILS_VERSION", "~> 8.1.0")

group :development, :test do
  gem "byebug"
  gem "sqlite3", "~> 2.9"
  gem "pg", "~> 1.5"
  gem "awesome_print"
  gem "sprockets-rails", "~> 3.5"
end

# To use a debugger
# gem 'byebug', group: [:development, :test]
