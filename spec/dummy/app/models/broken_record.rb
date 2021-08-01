class BrokenRecord < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  acts_as_association_scope only: [:user, :topic], except: [:topic]
end
