class Topic < ApplicationRecord
  belongs_to :user
  acts_as_association_scope
end
