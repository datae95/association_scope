class Picture < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  # has_association_scope_on [:imageable] # raises error on application start
end
