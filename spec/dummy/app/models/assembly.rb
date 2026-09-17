# frozen_string_literal: true

class Assembly < ApplicationRecord
  has_and_belongs_to_many :parts
  has_and_belongs_to_many :components, class_name: "Part", join_table: "assemblies_parts"
  has_and_belongs_to_many :active_parts, -> { where(active: true) }, class_name: "Part", join_table: "assemblies_parts"

  has_association_scope_on [:parts, :components]
  has_association_scope_on [:active_parts]
end
