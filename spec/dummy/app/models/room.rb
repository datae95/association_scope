# frozen_string_literal: true

class Room < ApplicationRecord
  belongs_to :house

  has_association_scope_on [:house]
end
