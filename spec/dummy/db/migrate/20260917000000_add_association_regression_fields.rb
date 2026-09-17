# frozen_string_literal: true

class AddAssociationRegressionFields < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :active, :boolean
    add_column :users, :code, :string
    add_column :users, :manager_id, :bigint
    add_column :topics, :published, :boolean
    add_column :topics, :user_code, :string
    add_column :parts, :active, :boolean
  end
end
