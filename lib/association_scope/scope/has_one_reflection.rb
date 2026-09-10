# frozen_string_literal: true

module AssociationScope
  class Scope
    class HasOneReflection < HasManyReflection
      def apply
        class_name = reflection_details.klass
        association = @association.pluralize
        column_name = reflection_details.options[:as] || model.to_s.underscore
        inverse_association = inverse_reflection(class_name, column_name)

        raise AssociationMissingError.new(missing_in: class_name, association: column_name) unless inverse_association

        association_scope = reflection_details.scope
        validate_scope!(reflection_details)
        polymorphic = reflection_details.options[:as]
        foreign_key = inverse_association.foreign_key
        target_table = class_name.table_name

        model.scope association, -> do
          relation = class_name
          relation = relation.instance_eval(&association_scope) if association_scope
          relation = relation.where(column_name => self) if polymorphic
          relation = relation.where(target_table => {foreign_key => self}) unless polymorphic
          relation = relation.distinct

          owner_column = polymorphic ? "#{column_name}_id" : foreign_key
          order_sql = relation.order_values.any? ? relation.arel.orders.map(&:to_sql).join(", ") : "#{target_table}.#{class_name.primary_key} ASC"
          order_sql = order_sql.gsub(%("#{target_table}".), "association_scope_source.")
          order_sql = order_sql.gsub("#{target_table}.", "association_scope_source.")
          selected_columns = relation.select_values
          inner = relation.except(:select, :order, :limit, :offset)
          ranked = <<~SQL.squish
            (SELECT association_scope_source.*, ROW_NUMBER() OVER (
              PARTITION BY association_scope_source.#{owner_column} ORDER BY #{order_sql}
            ) AS association_scope_row_number
            FROM (#{inner.to_sql}) association_scope_source) AS #{target_table}
          SQL

          relation = class_name.from(ranked).where(target_table => {association_scope_row_number: 1})
          selected_columns.any? ? relation.select(*selected_columns) : relation
        end
      end
    end
  end
end
