class Assembly < ApplicationRecord
  has_and_belongs_to_many :parts

  acts_as_association_scope
end
