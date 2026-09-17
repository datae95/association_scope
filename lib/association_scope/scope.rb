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
        scope_type = "HasManyReflection" if scope_type == "HasOneReflection"

        "AssociationScope::Scope::#{scope_type}".constantize.new(model, association).apply
      end
    end

    def self.target_relation(klass, *scopes)
      # Start independently of the owners' current scope, including for self joins.
      scopes.compact.reduce(klass.default_scoped) do |relation, scope|
        relation.instance_exec(&scope) || relation
      end
    end

    def self.one_per_owner(relation, owner_key)
      klass = relation.klass
      table = klass.arel_table
      orders = relation.arel.orders.presence || [table[klass.primary_key].asc]
      window = Arel::Nodes::Window.new.partition(owner_key).order(*orders)
      row_number = Arel::Nodes::NamedFunction.new("ROW_NUMBER", []).over(window)
      ranked = relation.except(:select, :order, :limit, :offset, :distinct)
        .select(table[Arel.star], row_number.as("association_scope_row_number"))

      # Keep ordering inside the window so offsets select a record for each owner.
      result = klass.unscoped.from(ranked, klass.table_name)
        .where(table[:association_scope_row_number].eq(relation.offset_value.to_i + 1))
        .distinct
      relation.select_values.any? ? result.select(*relation.select_values) : result
    end

    private

    def validate_scope!(reflection)
      scope = reflection.scope
      raise ArgumentError, "owner-dependent association scopes are not supported" if scope && scope.arity != 0
    end
  end
end
