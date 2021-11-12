class CreatePictures < ActiveRecord::Migration[6.1]
  def change
    create_table :pictures do |t|
      t.bigint :imageable_id
      t.string :imageable_type

      t.timestamps
    end

    add_index :pictures, [:imageable_type, :imageable_id]
  end
end
