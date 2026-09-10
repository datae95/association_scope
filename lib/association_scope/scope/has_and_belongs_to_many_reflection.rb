# frozen_string_literal: true

module AssociationScope
  class Scope
    class HasAndBelongsToManyReflection < Scope
      def apply
        association = @association.pluralize
        class_name = reflection_details.klass
        inverse_association = inverse_association(class_name)
        validate_scope!(reflection_details)
        association_scope = reflection_details.scope
        owner_table = model.table_name

        raise AssociationMissingError.new(missing_in: class_name, association: model.table_name) unless inverse_association

        model.scope association, -> do
          Scope.target_relation(class_name, association_scope)
            .joins(inverse_association)
            .where(owner_table => self)
            .distinct
        end
      end

      private

      def reflection_details
        model.reflections[association]
      end

      def inverse_association(class_name)
        class_name.reflections.values.find do |reflection|
          reflection.macro == :has_and_belongs_to_many &&
            reflection.klass == model &&
            reflection.join_table == reflection_details.join_table
        end&.name
      end
    end
  end
end
