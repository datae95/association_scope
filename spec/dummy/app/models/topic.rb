# frozen_string_literal: true

class Topic < ApplicationRecord
  belongs_to :user
  belongs_to :owner, class_name: "User", foreign_key: :user_id
  belongs_to :creator, class_name: "User", optional: true, foreign_key: "creator_id"
  has_one :account, through: :user

  has_many :likes
  has_many :likers, through: :likes, class_name: "User", source: :user, inverse_of: :liked_topics
  has_many :pictures, as: :imageable

  has_association_scope_on [:user, :creator, :account, :likes, :likers]
end
