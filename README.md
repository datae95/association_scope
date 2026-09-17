[![RSpec](https://github.com/datae95/association_scope/actions/workflows/rspec.yml/badge.svg)](https://github.com/datae95/association_scope/actions/workflows/rspec.yml)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/testdouble/standard)

# AssociationScope
I always wondered, why there was no functionality to use associations not only on `ActiveRecord` objects but on scopes as well.
When I have
```ruby
current_user.topics # => #<ActiveRecord::Relation [...]>
```
why can't I use the same construction on a collection of users like
```ruby
current_user.friends.topics # => #<ActiveRecord::Relation [...]>
```
and retrieve the collection of topics, my friends posted?
Instead I wrote weird scopes like
```ruby
class Topic < ApplicationRecord
  belongs_to :user
  scope :of_users, -> (users) { joins(:user).where(users: users) }
end
```
over and over again across all of my models to write something like `Topic.of_users(current_user.friends)` when I wanted to write `current_user.friends.topics` instead.
And `belongs_to` is the easiest part.

When you have this problem, the AssociationScope gem is for you!


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'association_scope'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install association_scope
```

## Usage
After installation you can use `has_association_scope_on` in your models:
```ruby
class Topic < ApplicationRecord
  belongs_to :user
  has_association_scope_on [:user]
end
```
Now you can use your associations as scopes and chain other scopes with them.
You can write
```ruby
Topic.all.users
```
to retrieve the users of all of the topics of your application.

The argument must be an array of association names.
Each generated relation scope uses the pluralized association name: `:user`
creates `.users`, and `:profile` creates `.profiles`. Names must be unique
after pluralization and must not already be defined as class methods/scopes.
There is no `only:` or `except:` option; list exactly the associations to
expose.

### Inverse associations

The association must have a matching inverse association on its target model.
AssociationScope uses that inverse to construct the join. Define both sides
before calling `has_association_scope_on`, and use `inverse_of` when the inverse
cannot be inferred (for example, with a custom `class_name` or `source`):

```ruby
class Topic < ApplicationRecord
  belongs_to :user, inverse_of: :topics
  has_association_scope_on [:user]
end

class User < ApplicationRecord
  has_many :topics, inverse_of: :user
end
```

### Supported association types

`has_association_scope_on` supports `belongs_to`, `has_one`, `has_many`,
`has_many :through`, `has_one :through`, and `has_and_belongs_to_many`
associations. Polymorphic `has_many` associations (for example,
`has_many :pictures, as: :imageable`) are supported. A polymorphic
`belongs_to` association is not supported because its target model cannot be
determined when the scope is defined.

### Migration from `.of_model`
When you already use any form of `.of_model` scope, you can replace it with association scopes:

```ruby
# replace
Topic.of_users(current_user.friends)
# with
current_user.friends.topics
```
When you chain scopes, you have to merge with the previous scope:
```ruby
# replace
scope.of_users(users)
# with
users.topics.merge(scope)
```

## Limitations
* This gem works with Active Record `reflections`.
To make this work, the `has_association_scope_on` call has to be below your association definitions.
```ruby
# won't work
class Topic
  has_association_scope_on [:user]
  belongs_to :user
end

# works
class Topic
  belongs_to :user
  has_association_scope_on [:user]
end
```
* Does not work for tables without primary key.
* To use `distinct` on rows, all values of this row must be of types other than JSON.
Workaround: Migrate JSON columns to JSONB.
* Error messages are not raised during application start, but on first instantiation, because of the order in which classes are loaded.

## Compatibility

The gem supports Ruby 3.2 through 4.0 and Rails 7.1 or newer. The CI matrix
tests Rails 7.1, 7.2, 8.0, and 8.1 on each supported Ruby version, using both
SQLite and PostgreSQL.

The test suite supports SQLite and PostgreSQL. PostgreSQL is recommended when
using `distinct` with JSON-valued columns; SQLite does not provide the same
JSON type behavior.

### Upgrade notes

Version 1.0 drops support for Ruby versions before 3.2 and Rails versions
before 7.1. Upgrade Ruby and Rails first, then run `bundle update
association_scope`. If you previously relied on a polymorphic `belongs_to`
association scope, replace it with an explicit application scope; that
association type is intentionally rejected. Also ensure every exposed
association has an inverse on its target model and remove unsupported
`only:`/`except:` arguments.

## Development
Clone this repository and run `bundle`.

The development Ruby version is 3.4.7. See [Compatibility](#compatibility) for
the supported runtime versions.

To use `rails console` you have to navigate to the dummy application 
```bash
$ cd spec/dummy
```

### Verification

Run the test suite with `bundle exec rake` (or `bundle exec rspec`). Check
formatting with `bundle exec standardrb` and dependencies with
`bundle exec bundler-audit check --update`. The CI matrix additionally runs
the suite on the supported Ruby/Rails combinations with SQLite and PostgreSQL.
