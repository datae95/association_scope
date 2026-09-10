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
        owner_table = model.arel_table
        target_table = class_name.arel_table
        join = target_table.join(owner_table).on(
          owner_table[foreign_key].eq(target_table[reflection_details.association_primary_key])
        ).join_sources
        join_sql = join.map(&:to_sql).join(" ")

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          scope association.pluralize, -> do
            class_name
              .joins(#{join_sql.inspect})
              .where(#{model.table_name.inspect} => { #{foreign_key.inspect} =>
                select(#{foreign_key.inspect}) })
              .distinct
          end
        RUBY
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
