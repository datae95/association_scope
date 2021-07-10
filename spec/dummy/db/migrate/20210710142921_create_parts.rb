class CreateParts < ActiveRecord::Migration[6.1]
  def change
    create_table :parts do |t|

      t.timestamps
    end
  end
end
