module AssociationScope
  class AssociationMissingError < StandardError
    attr_accessor :missing_in,
                  :association

    def initialize(missing_in: "Model", association: nil)
      @missing_in = missing_in
      @association = association
    end

    def message
      "Association #{association} missing in #{missing_in}!"
    end
  end
end
