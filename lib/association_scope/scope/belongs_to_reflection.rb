module AssociationScope
  class Scope
    class BelongsToReflection < Scope
      def apply
        association = @association
        details = model.reflections[association]
        class_name = details.options[:class_name]&.constantize || association.camelize.constantize
        association_name = association.to_s.underscore.to_sym
        foreign_key = details.options[:foreign_key]
        own_table_name = class_name.to_s.pluralize.underscore

        inverse_reflection = class_name.reflections[model.to_s.underscore.singularize] || class_name.reflections[model.to_s.underscore.pluralize]
        case inverse_reflection&.source_reflection&.class&.to_s&.split("::")&.last
        when "HasOneReflection"
          table_name = model.to_s.underscore.to_sym
        when "HasManyReflection"
          table_name = model.to_s.underscore.pluralize.to_sym
        else
          raise AssociationMissingError.new missing_in: class_name, association: model.to_s.underscore.pluralize
        end

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
    end
  end
end
