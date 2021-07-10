class Topic < ApplicationRecord
  belongs_to :user
  belongs_to :creator, class_name: 'User', optional: true
  acts_as_association_scope
end
