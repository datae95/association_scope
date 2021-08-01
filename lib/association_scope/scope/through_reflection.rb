module AssociationScope
  class Scope
    class ThroughReflection < Scope
      def apply
        details = model.reflections[@association]
        association = @association.pluralize
        class_name = details.options[:class_name]&.constantize || association.singularize.camelize.constantize

        inverse = details.options[:inverse_of]&.to_s || model.to_s.underscore
        inverse_reflection = class_name.reflections[inverse.singularize] || class_name.reflections[inverse.pluralize]
        first_join = inverse_reflection.options[:through] || inverse_reflection.options[:source]

        reflection_type = inverse_reflection.source_reflection.class.to_s.split("::").last
        second_join = if reflection_type == "HasOneReflection" || reflection_type == "BelongsToReflection"
          model.to_s.underscore.to_sym
        else
          model.to_s.underscore.pluralize.to_sym
        end

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
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
