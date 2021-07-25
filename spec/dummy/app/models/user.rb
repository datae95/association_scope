class User < ApplicationRecord
  has_many :topics
  has_many :posts, class_name: "Topic"
  has_one :account

  has_many :likes
  has_many :liked_topics, through: :likes, class_name: 'Topic', source: :topic, inverse_of: :likers

  acts_as_association_scope
end
