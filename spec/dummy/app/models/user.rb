# frozen_string_literal: true

class User < ApplicationRecord
  has_many :topics
  has_many :posts, class_name: "Topic"
  has_one :account
  has_one :topic
  has_one :owner_account, class_name: "Account", foreign_key: :user_id, inverse_of: :owner
  has_one :profile, class_name: "Account", foreign_key: :user_id, inverse_of: :profile_owner

  has_many :likes
  has_many :liked_topics, through: :likes, class_name: "Topic", source: :topic, inverse_of: :likers
  has_many :pictures, as: :imageable

  has_association_scope_on [:topics, :posts, :account, :profile, :likes, :liked_topics, :pictures]
end
