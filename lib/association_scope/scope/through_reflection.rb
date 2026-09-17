# frozen_string_literal: true

module AssociationScope
  class Scope
    class ThroughReflection < Scope
      def apply
        association = @association
        class_name = begin
          reflection_details.klass
        rescue ActiveRecord::AmbiguousSourceReflectionForThroughAssociation
          # Rails cannot resolve an omitted source when multiple source
          # reflections exist; retain the historical association-name
          # fallback for this inherently ambiguous case.
          association.singularize.camelize.constantize
        end
        source = begin
          reflection_details.source_reflection
        rescue ActiveRecord::AmbiguousSourceReflectionForThroughAssociation
          nil
        end
        validate_scope!(reflection_details)
        source ||= reflection_details.through_reflection.klass.reflections.values.find do |candidate|
          candidate.name.to_s == association.to_s && candidate.klass == class_name && candidate.through_reflection?
        end
        if source&.through_reflection?
          first_join = source.options[:through]
          second_join = reflection_details.options[:through].to_sym
        else
          first_join = inverse_reflection(class_name)&.options&.fetch(:through, nil) || inverse_reflection(class_name)&.options&.fetch(:source, nil)
          second_join = compute_second_join class_name
        end

        raise AssociationMissingError.new missing_in: class_name, association: inverse unless inverse_reflection(class_name)
        through_reflection = reflection_details.through_reflection
        through_table = through_reflection.klass.table_name
        through_key = through_reflection.belongs_to? ? through_reflection.association_primary_key : through_reflection.foreign_key
        source_key = through_reflection.belongs_to? ? through_reflection.foreign_key : through_reflection.active_record_primary_key
        owner_key = model.arel_table[source_key]
        partition_key = through_reflection.klass.arel_table[through_key]
        association_scope = reflection_details.scope
        source_scope = source&.scope
        validate_scope!(source) if source
        singular = reflection_details.macro == :has_one

        model.scope association.pluralize, -> do
          relation = Scope.target_relation(class_name, source_scope, association_scope)
            .joins(first_join => second_join)
            .where(through_table => {through_key => reselect(owner_key)})
          singular ? Scope.one_per_owner(relation, partition_key) : relation.distinct
        end
      end

      private

      def reflection_details
        model.reflections[association]
      end

      def inverse
        reflection_details.options[:inverse_of]&.to_s || model.to_s.underscore
      end

      def inverse_reflection class_name
        class_name.reflections[inverse.singularize] || class_name.reflections[inverse.pluralize]
      end

      def reflection_type class_name
        inverse_reflection(class_name)&.source_reflection&.class&.to_s&.split("::")&.last
      end

      def compute_second_join class_name
        if %w[HasOneReflection BelongsToReflection].include?(reflection_type(class_name))
          model.to_s.underscore.to_sym
        else
          model.to_s.underscore.pluralize.to_sym
        end
      end
    end
  end
end
