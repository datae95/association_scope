# frozen_string_literal: true

module AssociationScope
  class Scope
    class HasManyReflection < Scope
      def apply
        class_name = reflection_details.klass

        association = @association.pluralize
        column_name = reflection_details.options[:as] || model.to_s.underscore
        inverse_association = inverse_reflection(class_name, column_name)

        raise AssociationMissingError.new(missing_in: class_name, association: column_name) unless inverse_association

        association_scope = reflection_details.scope
        validate_scope!(reflection_details)
        polymorphic = reflection_details.options[:as]
        foreign_key = reflection_details.foreign_key
        owner_key = model.arel_table[reflection_details.active_record_primary_key]
        target_key = class_name.arel_table[foreign_key]
        foreign_type = reflection_details.type if polymorphic
        owner_type = model.polymorphic_name if polymorphic
        singular = reflection_details.macro == :has_one

        model.scope association, -> do
          relation = Scope.target_relation(class_name, association_scope)
            .where(target_key.in(reselect(owner_key).arel))
          relation = relation.where(foreign_type => owner_type) if polymorphic
          singular ? Scope.one_per_owner(relation, target_key) : relation.distinct
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
