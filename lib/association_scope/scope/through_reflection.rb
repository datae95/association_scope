# frozen_string_literal: true

module AssociationScope
  class Scope
    class ThroughReflection < Scope
      def apply
        association = @association
        class_name = reflection_details.options[:class_name]&.constantize || association.singularize.camelize.constantize
        source = reflection_details.options[:source] && reflection_details.source_reflection
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
        source_table = model.table_name
        source_primary_key = model.primary_key
        through_reflection = reflection_details.through_reflection
        through_table = through_reflection.klass.table_name
        through_key = through_reflection.belongs_to? ? through_reflection.klass.primary_key : through_reflection.foreign_key
        source_key = through_reflection.belongs_to? ? through_reflection.foreign_key : source_primary_key

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          scope association.pluralize, -> do
            source_relation = self
            class_name
              .joins(first_join => second_join)
              .where(#{through_table.inspect} => { #{through_key.inspect} =>
                source_relation.reselect(#{"#{source_table}.#{source_key}".inspect}) })
              .distinct
          end
        RUBY
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
