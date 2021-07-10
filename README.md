# AssociationScope
I always wondered, why there was no functionality to use associations not only on active_record object but on scopes as well.
When I have
```ruby
current_user.topics # => #<ActiveRecord::Relation [...]>
```
why can't I use this on a collection of users like
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
over and over again across all of my models to write `Topic.of_users(users)` when I want to write `users.topics` instead.
And `belongs_to` is the easiest part.

When you have this problem, this gem is for you!

## Usage
How to use my plugin.

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

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
