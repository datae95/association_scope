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
over and over again across all of my models to write `Topic.of_users(current_user.friends)` when I wanted to write `current_user.friends.topics` instead.
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
After installation you can use `acts_as_association_scope` in your models:
```ruby
class Topic < ApplicationRecord
  belongs_to :user
  acts_as_association_scope
end
```
Now you can use your associations as scopes and chain other scopes with them.
You can write
```ruby
Topic.all.users
```
to retrieve the users of all of the topics of your application.

## Known Issues
* This gem works with `reflections`.
To make this work, the `acts_as_association_scope` call has to be below your association definitions.
```ruby
# won't work
class Topic
  acts_as_association_scope
  belongs_to :user
end

# works
class Topic
  belongs_to :user
  acts_as_association_scope
end
```
* Database views do not have a primary key.
To use `distinct` on rows, all values of this row must be of types other than json.
Workaround: Migrate JSON columns to JSONB.
* Error messages are not raised during application start, but on first instantiation, because of the order in which classes are loaded.

## Development
Clone this repository and run `bundle`.
To use `rails console` you have to navigate to the dummy application `cd spec/dummy`.