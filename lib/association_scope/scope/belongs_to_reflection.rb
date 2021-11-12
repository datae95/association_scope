# frozen_string_literal: true

module AssociationScope
  class Scope
    class BelongsToReflection < Scope
      def apply
        association = @association
        class_name = reflection_details.options[:class_name]&.constantize || association.camelize.constantize
        foreign_key = reflection_details.options[:foreign_key]
        association_name = association.to_s.underscore.to_sym
        own_table_name = class_name.to_s.pluralize.underscore
        table_name = table_name class_name

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          scope association.pluralize, -> do
            if foreign_key.present?
              class_name
                .joins("JOIN #{table_name} ON #{table_name}.#{foreign_key} = #{own_table_name}.id")
            else
              class_name
                .joins(table_name)
            end
              .where(table_name => { association_name =>
                select("#{association_name}_id".to_sym) })
              .distinct
          end
        RUBY
      end

      private

      def table_name(class_name)
        case inverse_reflection(class_name)&.source_reflection&.class&.to_s&.split("::")&.last
        when "HasOneReflection"
          model.to_s.underscore.to_sym
        when "HasManyReflection"
          model.to_s.underscore.pluralize.to_sym
        else
          raise AssociationMissingError.new missing_in: class_name, association: model.to_s.underscore.pluralize
        end
      end

      def inverse_reflection(class_name)
        class_name.reflections[model.to_s.underscore.singularize] || class_name.reflections[model.to_s.underscore.pluralize]
      end

      def reflection_details
        model.reflections[association]
      end
    end
  end
end
