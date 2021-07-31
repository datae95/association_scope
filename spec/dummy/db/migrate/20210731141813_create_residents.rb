class CreateResidents < ActiveRecord::Migration[6.1]
  def change
    create_table :residents do |t|

      t.timestamps
    end
  end
end
