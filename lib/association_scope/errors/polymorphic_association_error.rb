# frozen_string_literal: true

module AssociationScope
  class PolymorphicAssociationError < StandardError
    attr_accessor :association,
      :model

    def initialize(association: nil, model: nil)
      @association = association
      @model = model
    end

    def message
      "Association :#{association} is polymorph in #{model}!"
    end
  end
end
