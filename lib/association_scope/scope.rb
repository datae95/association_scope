# frozen_string_literal: true

module AssociationScope
  class Scope
    attr_reader :model, :association

    def initialize(model, association)
      @model = model
      @association = association
    end

    private

    def validate_scope!(reflection)
      scope = reflection.scope
      raise ArgumentError, "owner-dependent association scopes are not supported" if scope && scope.arity != 0
    end

    def self.inject_scopes(model, reflections)
      model.reflections.slice(*reflections).each do |association, details|
        scope_type = details.class.to_s.split("::").last

        "AssociationScope::Scope::#{scope_type}".constantize.new(model, association).apply
      end
    end
  end
end
