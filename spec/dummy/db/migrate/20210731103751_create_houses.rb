# frozen_string_literal: true

class CreateHouses < ActiveRecord::Migration[6.1]
  def change
    create_table :houses do |t|
      t.references :owner, null: false, foreign_key: true
      t.references :holder, null: false, foreign_key: true

      t.timestamps
    end
  end
end
