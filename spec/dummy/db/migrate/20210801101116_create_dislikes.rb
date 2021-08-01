# frozen_string_literal: true

class CreateDislikes < ActiveRecord::Migration[6.1]
  def change
    create_table :dislikes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
