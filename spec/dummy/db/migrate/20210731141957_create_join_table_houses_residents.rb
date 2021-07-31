class CreateJoinTableHousesResidents < ActiveRecord::Migration[6.1]
  def change
    create_join_table :houses, :residents do |t|
      # t.index [:house_id, :resident_id]
      # t.index [:resident_id, :house_id]
    end
  end
end
