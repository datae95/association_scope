# frozen_string_literal: true

class Part < ApplicationRecord
  has_and_belongs_to_many :assemblies
  has_and_belongs_to_many :devices, class_name: "Assembly", join_table: "assemblies_parts"

  has_association_scope_on [:assemblies, :devices]
end
