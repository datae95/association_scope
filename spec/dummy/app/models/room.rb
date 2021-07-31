class Room < ApplicationRecord
  belongs_to :house

  acts_as_association_scope
end
