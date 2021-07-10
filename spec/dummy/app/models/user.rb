class User < ApplicationRecord
  has_many :topics
  acts_as_association_scope
end
