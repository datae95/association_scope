class User < ApplicationRecord
  has_many :topics
  has_many :posts, class_name: 'Topic'
  acts_as_association_scope
end
