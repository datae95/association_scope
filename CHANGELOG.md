# Changelog

All notable changes to this project are documented in this file.

## Unreleased

### Changed

- Support is now limited to Ruby 3.2 through 3.4 and Rails 7 or newer.
- The development and test dependencies are pinned and the CI suite explicitly
  tests the supported Ruby and Rails versions.

### Upgrade notes

- Upgrade to Ruby 3.2 or newer and Rails 7 or newer before updating the gem.
- Replace polymorphic `belongs_to` association scopes with explicit application
  scopes; they are not supported.

## 0.4.0 - 2021-11-12

### Added

- Polymorphic association behavior and test coverage.

## 0.3.3 - 2021-11-12

### Changed

- Updated development dependencies and CI configuration.

## 0.3.0

See the [v0.3.0 release](https://github.com/datae95/association_scope/tree/v0.3.0)
for the changes in this release.
