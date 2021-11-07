# frozen_string_literal: true

class Holder < ApplicationRecord
  has_one :house

  has_association_scope_on [:house]
end
