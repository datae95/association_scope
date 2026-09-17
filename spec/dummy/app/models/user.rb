# frozen_string_literal: true

class User < ApplicationRecord
  has_and_belongs_to_many :friends, class_name: "User", join_table: "friendships",
    foreign_key: :user_id, association_foreign_key: :friend_id
  has_many :topics
  has_many :scoped_topics, -> { where(id: 1) }, class_name: "Topic"
  has_many :posts, class_name: "Topic"
  has_many :coded_topics, class_name: "Topic", foreign_key: :user_code, primary_key: :code, inverse_of: :coded_user
  has_one :first_coded_topic, class_name: "Topic", foreign_key: :user_code, primary_key: :code, inverse_of: :coded_user
  belongs_to :manager, class_name: "User", optional: true, inverse_of: :reports
  has_many :reports, class_name: "User", foreign_key: :manager_id, inverse_of: :manager
  has_one :account
  has_one :topic
  has_one :latest_topic, -> { order(id: :desc).limit(1) }, class_name: "Topic"
  has_one :selected_topic, -> { select(:id, :user_id).order(id: :desc) }, class_name: "Topic"
  has_one :second_topic, -> { order(id: :asc).offset(1) }, class_name: "Topic"
  has_one :owner_account, class_name: "Account", foreign_key: :user_id, inverse_of: :owner
  has_one :profile, class_name: "Account", foreign_key: :user_id, inverse_of: :profile_owner

  has_many :likes
  has_many :liked_topics, through: :likes, class_name: "Topic", source: :topic, inverse_of: :likers
  has_many :published_liked_topics, -> { where(published: true) }, through: :likes, source: :topic, inverse_of: :likers
  has_many :pictures, as: :imageable

  has_association_scope_on [:topics, :scoped_topics, :posts, :account, :profile, :latest_topic, :selected_topic, :likes, :liked_topics, :pictures]
  has_association_scope_on [:coded_topics, :first_coded_topic, :manager, :second_topic, :published_liked_topics]
end
