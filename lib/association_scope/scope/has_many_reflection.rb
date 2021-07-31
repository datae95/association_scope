module AssociationScope
  class Scope
    class HasManyReflection < Scope
      def apply
        details = model.reflections[@association]
        class_name = details.options[:class_name]&.constantize || association.singularize.camelize.constantize
        association = @association.pluralize
        column_name = model.to_s.underscore

        raise AssociationMissingError.new(missing_in: class_name, association: column_name) unless class_name.reflections.has_key?(column_name)

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          scope association, -> do
            class_name
              .where(column_name => self)
              .distinct
          end
        RUBY
      end
    end
  end
end