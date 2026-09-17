# Changelog

All notable changes to this project are documented in this file.

## 1.0.0 - 2026-09-10

### Changed

- Support is now limited to Ruby 3.2 through 4.0 and Rails 7.1 or newer.
- The development and test dependencies are pinned and the CI suite explicitly
  tests the supported Ruby, Rails, and database adapter versions (SQLite and
  PostgreSQL).

### Fixed

- Preserve scoped `belongs_to`, through, and HABTM association predicates.
- Support explicit source selections and self-referential `belongs_to` scopes.
- Honor custom association primary keys for direct associations.
- Return one record per owner for `has_one :through`, preserving source order
  and applying offsets per owner for both direct and through `has_one` scopes.
- Exercise real queries and chaining in the installed-gem smoke test.

### Documentation

- Documented inverse-association requirements, generated scope naming,
  unsupported options, upgrade notes, and verification commands.

### Upgrade notes

- Upgrade to Ruby 3.2 or newer and Rails 7.1 or newer before updating the gem.
- Replace polymorphic `belongs_to` association scopes with explicit application
  scopes; they are not supported.
- Association scopes now require the corresponding inverse association on the
  target model. Add `inverse_of` when Rails cannot infer that association.
- `has_association_scope_on` accepts only an association name or an array of
  association names. It does not accept `only:` or `except:` options.

## 0.4.0 - 2021-11-12

### Added

- Polymorphic association behavior and test coverage.

## 0.3.3 - 2021-11-12

### Changed

- Updated development dependencies and CI configuration.

## 0.3.0

See the [v0.3.0 release](https://github.com/datae95/association_scope/tree/v0.3.0)
for the changes in this release.
