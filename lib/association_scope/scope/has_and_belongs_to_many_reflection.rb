# frozen_string_literal: true

module AssociationScope
  class Scope
    class HasAndBelongsToManyReflection < Scope
      def apply
        association = @association.pluralize
        class_name = reflection_details.options[:class_name]&.constantize || association.singularize.camelize.constantize
        table_name = model.to_s.underscore.pluralize.to_sym

        raise AssociationMissingError.new(missing_in: class_name, association: table_name) unless class_name.reflections.has_key?(table_name.to_s)

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          scope association, -> do
            class_name
              .joins(table_name)
              .where(table_name => self)
              .distinct
          end
        RUBY
      end

      private

      def reflection_details
        model.reflections[association]
      end
    end
  end
end
