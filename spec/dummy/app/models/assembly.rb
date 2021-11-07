# frozen_string_literal: true

class Assembly < ApplicationRecord
  has_and_belongs_to_many :parts

  has_association_scope_on [:parts]
end
