# TODO
#   Polymorphy
#   What happens with multiple join tables for the same models?

# Registers association scopes for every association
#   belongs_to
#   Optional true
#   has_many
#   has_one
#   has_and_belongs_to_many
#   Through
#   Named associations
#   Inverse

# Known Issues:
#   Views do not have a primary key. To use distinct on rows, all values of this row must be of types other than json. Workaround: Migrate JSON columns to JSONB
#   `acts_as_associationscope` method must be placed below of association definitions
module AssociationScopes
  extend ActiveSupport::Concern
end

module ActiveRecord
  class Base
    def self.acts_as_associationscope only: self.reflections.keys, except: []
      # Apply given filters.
      # Don't be picky about singular or plural. Pluralize everything.
      raise ArgumentError.new("Don't use :only and :except together!") unless only == self.reflections.keys || except == []
      reflections = self.reflections.select{|key, _r| only.map(&:to_s).map(&:pluralize).include?(key.to_s.pluralize) && !except.map(&:to_s).map(&:pluralize).include?(key.to_s.pluralize) }

      # For each reflection create an association scope.
      reflections.each do |association, reflection|
        reflection_type = reflection.class.to_s.split("::").last
        class_name = reflection.options[:class_name]&.constantize || association.singularize.camelize.constantize
        column_name = reflection.options[:inverse_of]&.to_s || reflection.options[:foreign_key]&.to_s&.split("_")&.first

        case reflection_type
        # The only difference between has many and has one is the singular or plural in associations name. So pluralizing it in both cases, makes the code dry.
        when "HasManyReflection", "HasOneReflection"
          scope association.pluralize.to_sym, -> do
            column_name ||= reflection.options[:as] || self.class.to_s.split("::").first.underscore.to_sym

            class_name
              .where(column_name => self)
              .distinct
          end
        when "BelongsToReflection"
          column_name ||= association.singularize.to_sym
          identifier = "#{column_name}_id".to_sym
          foreign_key = reflection.options[:foreign_key]

          # The other side of the association can be has many or has one.

          scope association.pluralize.to_sym, -> do
            reflection_name = self.class.to_s.split("::")&.first&.underscore
            table_name = if class_name.reflections.keys.include? reflection_name
              reflection_name.to_sym
            else
              reflection_name.pluralize.to_sym
            end

            if foreign_key.present?
              own_table_name = class_name.to_s.pluralize.underscore
              class_name
                .joins("JOIN #{table_name.to_s} ON #{table_name.to_s}.#{foreign_key} = #{own_table_name}.id")
            else
              class_name
                .joins(table_name)
            end
              .where(table_name => { identifier => select(identifier) })
              .distinct
          end
        when "HasAndBelongsToManyReflection"

          scope association.pluralize.to_sym, -> do
            table_name = self.class.to_s.split("::")&.first&.underscore.pluralize.to_sym
            class_name
              .joins(table_name)
              .where(table_name => self)
              .distinct
          end
        when "ThroughReflection"
          # where to get singular/plural
          new_reflection = reflection.name.to_s.singularize.camelize.constantize.reflections[self.to_s.underscore.pluralize]
          second_join = new_reflection&.options[:through]&.to_s&.to_sym
          first_join = reflections[first_join.to_s]&.options&.has_key?(:inverse_of) ? reflections[first_join.to_s]&.options[:inverse_of] : new_reflection.active_record.to_s.underscore.to_sym

          scope association.pluralize.to_sym, -> do
            class_name
              .joins(first_join => second_join)
              .where(first_join => { second_join => self})
              .distinct
          end
        end
      rescue NoMethodError => e
        puts "There is no corresponding association :#{self.to_s.underscore.pluralize} in #{reflection.name.to_s.singularize.camelize.constantize}"
      rescue NameError => e
        puts "add association #{association} explicitly: explicit: {#{association}: class_name}"
      end
    end
  end
end