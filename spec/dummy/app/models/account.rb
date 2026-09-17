# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :user
  belongs_to :owner, class_name: "User", foreign_key: :user_id, inverse_of: :owner_account
  belongs_to :profile_owner, class_name: "User", foreign_key: :user_id, inverse_of: :profile
  has_many :topics, through: :user
  has_many :liked_topics, through: :user, class_name: "Topic"
  has_one :topic, through: :user
  has_one :first_topic, through: :user, source: :topic, inverse_of: :account
  has_one :latest_topic, through: :user, source: :latest_topic, inverse_of: :account
  has_one :second_topic, through: :user, source: :second_topic, inverse_of: :account

  has_association_scope_on [:user, :owner, :topics, :liked_topics]
  has_association_scope_on [:first_topic, :latest_topic, :second_topic]
end
