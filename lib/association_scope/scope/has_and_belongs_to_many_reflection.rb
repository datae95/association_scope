# frozen_string_literal: true

module AssociationScope
  class Scope
    class HasAndBelongsToManyReflection < Scope
      def apply
        association = @association.pluralize
        class_name = reflection_details.options[:class_name]&.constantize || association.singularize.camelize.constantize
        inverse_association = inverse_association(class_name)

        raise AssociationMissingError.new(missing_in: class_name, association: model.table_name) unless inverse_association

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          scope association, -> do
            class_name
              .joins(inverse_association)
              .where(model.table_name => self)
              .distinct
          end
        RUBY
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
