class CreateBrokenRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :broken_records do |t|
      t.references :user, null: false, foreign_key: true
      t.references :topic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
