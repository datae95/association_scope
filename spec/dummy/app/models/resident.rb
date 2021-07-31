class Resident < ApplicationRecord
  acts_as_association_scope
  has_and_belongs_to_many :houses
end
