# frozen_string_literal: true

class Resident < ApplicationRecord
  has_and_belongs_to_many :houses
  has_association_scope_on [:houses]
end
