# frozen_string_literal: true

class CreateFriendships < ActiveRecord::Migration[7.1]
  def change
    create_table :friendships, id: false do |t|
      t.references :user, null: false, foreign_key: true
      t.references :friend, null: false, foreign_key: {to_table: :users}
    end
  end
end
