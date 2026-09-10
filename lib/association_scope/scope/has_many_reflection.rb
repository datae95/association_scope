# frozen_string_literal: true

module AssociationScope
  class Scope
    class HasManyReflection < Scope
      def apply
        class_name = reflection_details.options[:class_name]&.constantize || association.singularize.camelize.constantize

        association = @association.pluralize
        column_name = reflection_details.options[:as] || model.to_s.underscore
        inverse_association = inverse_reflection(class_name, column_name)

        raise AssociationMissingError.new(missing_in: class_name, association: column_name) unless inverse_association

        condition = if reflection_details.options[:as]
          "#{column_name.inspect} => self"
        else
          "#{class_name.table_name.inspect} => { #{inverse_association.foreign_key.inspect} => self }"
        end

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          scope association, -> do
            class_name
              .where(#{condition})
              .distinct
          end
        RUBY
      end

      private

      def reflection_details
        model.reflections[@association]
      end

      def inverse_reflection(class_name, column_name)
        inverse_name = reflection_details.options[:inverse_of]

        class_name.reflections[inverse_name.to_s] || class_name.reflections[column_name.to_s]
      end
    end
  end
end
