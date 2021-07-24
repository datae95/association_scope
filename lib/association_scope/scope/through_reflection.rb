module AssociationScope
  class Scope
    class ThroughReflection < Scope
      def apply
        details = model.reflections[@association]
        association = @association.pluralize
        class_name = details.options[:class_name]&.constantize || association.singularize.camelize.constantize
        first_join = details.options[:through]
        second_join = model.to_s.underscore.to_sym

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