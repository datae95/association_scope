# frozen_string_literal: true

module AssociationScope
  class Scope
    class ThroughReflection < Scope
      def apply
        association = @association
        class_name = reflection_details.options[:class_name]&.constantize || association.singularize.camelize.constantize
        first_join = inverse_reflection(class_name)&.options&.fetch(:through, nil) || inverse_reflection(class_name)&.options&.fetch(:source, nil)
        second_join = compute_second_join class_name

        raise AssociationMissingError.new missing_in: class_name, association: inverse unless inverse_reflection(class_name)

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          scope association.pluralize, -> do
            class_name
              .joins(first_join => second_join)
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
        if %w[HasOneReflection BelongsToReflection].include?(reflection_type class_name)
          model.to_s.underscore.to_sym
        else
          model.to_s.underscore.pluralize.to_sym
        end
      end
    end
  end
end
