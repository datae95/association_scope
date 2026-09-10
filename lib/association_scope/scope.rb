# frozen_string_literal: true

module AssociationScope
  class Scope
    attr_reader :model, :association

    def initialize(model, association)
      @model = model
      @association = association
    end

    def self.inject_scopes(model, reflections)
      unknown_association = reflections.find { |association| !model.reflections.key?(association) }
      if unknown_association
        raise AssociationMissingError.new(missing_in: model, association: unknown_association)
      end

      generated_scopes = reflections.map(&:pluralize)
      if generated_scopes.uniq.length != generated_scopes.length
        raise ArgumentError, "association scope names must be unique after pluralization"
      end

      generated_scopes.each do |scope_name|
        if model.respond_to?(scope_name)
          raise ArgumentError, "association scope :#{scope_name} is already defined on #{model}"
        end
      end

      model.reflections.slice(*reflections).each do |association, details|
        scope_type = details.class.to_s.split("::").last

        "AssociationScope::Scope::#{scope_type}".constantize.new(model, association).apply
      end
    end

    private

    def validate_scope!(reflection)
      scope = reflection.scope
      raise ArgumentError, "owner-dependent association scopes are not supported" if scope && scope.arity != 0
    end
  end
end
