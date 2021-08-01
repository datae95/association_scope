# frozen_string_literal: true

class CreateTopics < ActiveRecord::Migration[6.1]
  def change
    create_table :topics do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :creator_id

      t.timestamps
    end
    add_foreign_key :topics, :users, column: :creator_id
  end
end
