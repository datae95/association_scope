# frozen_string_literal: true

require "association_scope/version"
require "association_scope/scope"
require "association_scope/scope/has_many_reflection"
require "association_scope/scope/has_one_reflection"
require "association_scope/scope/belongs_to_reflection"
require "association_scope/scope/has_and_belongs_to_many_reflection"
require "association_scope/scope/through_reflection"

require "association_scope/errors/association_missing_error"
require "association_scope/errors/polymorphic_association_error"

module AssociationScope
end

module ActiveRecord
  class Base
    def self.has_association_scope_on(models)
      models = models.map(&:to_s)
      ::AssociationScope::Scope.inject_scopes(self, models)
    end
  end
end
