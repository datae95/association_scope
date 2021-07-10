class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def inspect
    "#{self.class}##{self.id}"
  end
end
