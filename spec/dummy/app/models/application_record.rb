class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def inspect
    "#{self.class}##{id}"
  end
end
