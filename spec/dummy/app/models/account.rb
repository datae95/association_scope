# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :user
  belongs_to :owner, class_name: "User", foreign_key: :user_id, inverse_of: :owner_account
  belongs_to :profile_owner, class_name: "User", foreign_key: :user_id, inverse_of: :profile
  has_many :topics, through: :user
  has_many :liked_topics, through: :user, class_name: "Topic"
  has_one :topic, through: :user

  has_association_scope_on [:user, :owner, :topics, :liked_topics]
end
