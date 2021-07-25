module AssociationScope
  class Scope
    class ThroughReflection < Scope
      def apply
        details = model.reflections[@association]
        association = @association.pluralize
        class_name = details.options[:class_name]&.constantize || association.singularize.camelize.constantize

        new_reflection = class_name.reflections[model.to_s.underscore.singularize] || class_name.reflections[model.to_s.underscore.pluralize]
        first_join = new_reflection.options[:through]
        second_join = if new_reflection.source_reflection.class.to_s.split("::").last == "HasOneReflection"
          model.to_s.underscore.to_sym
        else
          model.to_s.underscore.pluralize.to_sym
        end

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          scope association.pluralize, -> do
            class_name
              .joins(first_join => second_join)
              .where(first_join => {second_join => self})
              .distinct
          end
        RUBY
      end
    end
  end
end