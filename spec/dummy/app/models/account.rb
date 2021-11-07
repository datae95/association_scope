# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :user
  belongs_to :owner, class_name: "User", foreign_key: :user_id
  has_many :topics, through: :user

  has_association_scope_on [:user, :topics]
end
