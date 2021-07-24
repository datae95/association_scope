class User < ApplicationRecord
  has_many :topics
  has_many :posts, class_name: "Topic"
  # has_one :account

  acts_as_association_scope
end
