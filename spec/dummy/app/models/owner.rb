class Owner < ApplicationRecord
  has_many :houses

  acts_as_association_scope
end
