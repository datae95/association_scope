# frozen_string_literal: true

class Topic < ApplicationRecord
  belongs_to :user
  belongs_to :active_user, -> { where(active: true) }, class_name: "User", foreign_key: :user_id, inverse_of: :topics, optional: true
  belongs_to :coded_user, class_name: "User", foreign_key: :user_code, primary_key: :code, inverse_of: :coded_topics, optional: true
  belongs_to :owner, class_name: "User", foreign_key: :user_id
  belongs_to :creator, class_name: "User", optional: true, foreign_key: "creator_id"
  has_one :account, through: :user

  has_many :likes
  has_many :likers, through: :likes, class_name: "User", source: :user, inverse_of: :liked_topics
  has_many :pictures, as: :imageable

  has_association_scope_on [:user, :creator, :account, :likes, :likers, :pictures]
  has_association_scope_on [:active_user, :coded_user]
end
