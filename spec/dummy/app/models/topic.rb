class Topic < ApplicationRecord
  belongs_to :user
  belongs_to :creator, class_name: 'User', optional: true, foreign_key: 'creator_id'

  acts_as_association_scope
end
