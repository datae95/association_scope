module AssociationScope
  class Scope
    class HasAndBelongsToManyReflection < Scope
      def apply
        association = @association.pluralize
        details = model.reflections[association]
        class_name = details.options[:class_name]&.constantize || association.singularize.camelize.constantize
        table_name = model.to_s.underscore.pluralize.to_sym

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          scope association, -> do
            class_name
              .joins(table_name)
              .where(table_name => self)
              .distinct
          end
        RUBY
      end
    end
  end
end