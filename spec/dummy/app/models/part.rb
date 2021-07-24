class Part < ApplicationRecord
  has_and_belongs_to_many :assemblies

  # acts_as_association_scope
end
