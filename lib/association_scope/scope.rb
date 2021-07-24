module AssociationScope
  class Scope
    attr_reader :model, :association, :details

    def initialize(model, association, details)
      @model = model
      @association = association
      @details = details
    end

    def self.inject_scopes(model)
      model.reflections.each do |association, details|
        scope_type = details.class.to_s.split('::').last
        "AssociationScope::Scope::#{scope_type}".constantize.new(model, association, details).apply #if const_defined?(scope_type)
      end
    end
  end
end