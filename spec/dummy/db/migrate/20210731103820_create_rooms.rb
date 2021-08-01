# frozen_string_literal: true

class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.references :house, null: false, foreign_key: true

      t.timestamps
    end
  end
end
