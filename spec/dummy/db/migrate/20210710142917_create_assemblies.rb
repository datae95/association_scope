# frozen_string_literal: true

class CreateAssemblies < ActiveRecord::Migration[6.1]
  def change
    create_table :assemblies do |t|
      t.timestamps
    end

    create_table :assemblies_parts, id: false do |t|
      t.belongs_to :assembly
      t.belongs_to :part
    end
  end
end
