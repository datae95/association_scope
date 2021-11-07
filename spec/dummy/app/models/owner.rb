# frozen_string_literal: true

class Owner < ApplicationRecord
  has_many :houses

  has_association_scope_on [:houses]
end
