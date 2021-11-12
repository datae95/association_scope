# frozen_string_literal: true

module AssociationScope
  class Scope
    class ThroughReflection < Scope
      def apply
        association = @association

        reflection_details = model.reflections[association]
        class_name = reflection_details.options[:class_name]&.constantize || association.singularize.camelize.constantize
        inverse = reflection_details.options[:inverse_of]&.to_s || model.to_s.underscore

        inverse_reflection = class_name.reflections[inverse.singularize] || class_name.reflections[inverse.pluralize]
        first_join = inverse_reflection&.options&.fetch(:through, nil) || inverse_reflection&.options&.fetch(:source, nil)
        reflection_type = inverse_reflection&.source_reflection&.class&.to_s&.split("::")&.last

        second_join = if %w[HasOneReflection BelongsToReflection].include?(reflection_type)
          model.to_s.underscore.to_sym
        else
          model.to_s.underscore.pluralize.to_sym
        end

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          raise AssociationMissingError.new missing_in: class_name, association: inverse unless inverse_reflection
          scope association.pluralize, -> do
            class_name
              .joins(first_join => second_join)
              .distinct
          end
        RUBY
      end
    end
  end
end
