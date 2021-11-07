class BrokenRecord < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  has_association_scope_on only: [:user, :topic], except: [:topic]
end
