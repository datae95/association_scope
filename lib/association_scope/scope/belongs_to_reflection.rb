module AssociationScope
  class Scope
    class BelongsToReflection < Scope
      def apply
        association = @association
        model = @model
        class_name = association.camelize.constantize
        table_name = model.to_s.underscore.pluralize.to_sym
        association_name = association.to_s.underscore.to_sym

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          scope association.pluralize, -> do
            class_name
              .joins(table_name)
              .where(table_name => { association_name => self })
              .distinct
          end
        RUBY
      end
    end
  end
end