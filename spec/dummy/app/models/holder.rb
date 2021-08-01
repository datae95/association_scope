# frozen_string_literal: true

class Holder < ApplicationRecord
  has_one :house

  acts_as_association_scope
end
