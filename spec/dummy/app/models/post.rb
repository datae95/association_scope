# frozen_string_literal: true

class Post < ApplicationRecord
  has_many :dislikes
  has_many :dislikers, through: :dislikes,
                       class_name: "User",
                       source: :user,
                       foreign_key: :post_id,
                       inverse_of: :disliked_posts

  has_association_scope_on [:dislkes, :dislikers]
end
