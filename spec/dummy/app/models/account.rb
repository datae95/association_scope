class Account < ApplicationRecord
  belongs_to :user
  has_many :topics, through: :user

  # acts_as_association_scope
end
