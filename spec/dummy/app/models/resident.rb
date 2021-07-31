class Resident < ApplicationRecord
  has_and_belongs_to_many :houses
  acts_as_association_scope
end
