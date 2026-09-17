# frozen_string_literal: true

module AssociationScope
  class Scope
    class BelongsToReflection < Scope
      def apply
        if reflection_details.options[:polymorphic]
          raise PolymorphicAssociationError.new association: association, model: model
        end

        association = @association
        class_name = reflection_details.klass
        inverse_association = inverse_reflection(class_name)

        unless inverse_association
          raise AssociationMissingError.new missing_in: class_name, association: model.to_s.underscore.pluralize
        end

        foreign_key = reflection_details.foreign_key
        validate_scope!(reflection_details)
        association_scope = reflection_details.scope
        owner_key = model.arel_table[foreign_key]
        target_key = class_name.arel_table[reflection_details.association_primary_key]

        model.scope association.pluralize, -> do
          Scope.target_relation(class_name, association_scope)
            .where(target_key.in(reselect(owner_key).arel))
            .distinct
        end
      end

      private

      def inverse_reflection(class_name)
        inverse_name = reflection_details.options[:inverse_of]

        class_name.reflections[inverse_name.to_s] ||
          class_name.reflections[model.to_s.underscore.singularize] ||
          class_name.reflections[model.to_s.underscore.pluralize]
      end

      def reflection_details
        model.reflections[association]
      end
    end
  end
end
