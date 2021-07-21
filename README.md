# AssociationScope
I always wondered, why there was no functionality to use associations not only on active_record object but on scopes as well.
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
over and over again across all of my models to write `Topic.of_users(users)` when I want to write `users.topics` instead.
And `belongs_to` is the easiest part.

When you have this problem, this gem is for you!


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
When you have the classes `User` with many `Topic`s and every `Topic` has many `Post`s with many `Comment`s and all of them call `acts_as_association_scope`, you can write
```ruby
User.first.topics.posts.comments
```
to retrieve all comments of all posts of all topics of your first user.

## Development
Clone the app and run `bundle`.
To use `rails console` you have to navigate to the dummy application `cd spec/dummy`.

## Known Issues
* This gem works with `reflections`.
To make this work, the `acts_as_association_scope` call has to be below your association definitions.
* Database views do not have a primary key.
To use distinct on rows, all values of this row must be of types other than json.
Workaround: Migrate JSON columns to JSONB
