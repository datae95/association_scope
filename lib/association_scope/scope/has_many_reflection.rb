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

        association_scope = reflection_details.scope
        polymorphic = reflection_details.options[:as]
        foreign_key = inverse_association.foreign_key
        target_table = class_name.table_name

        model.scope association, -> do
          relation = class_name
          relation = relation.instance_eval(&association_scope) if association_scope
          if polymorphic
            relation.where(column_name => self).distinct
          else
            relation.where(target_table => {foreign_key => self}).distinct
          end
        end
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
