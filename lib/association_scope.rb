# frozen_string_literal: true

require "association_scope/version"
require "association_scope/scope"
require "association_scope/scope/has_many_reflection"
require "association_scope/scope/has_one_reflection"
require "association_scope/scope/belongs_to_reflection"
require "association_scope/scope/has_and_belongs_to_many_reflection"
require "association_scope/scope/through_reflection"

require "association_scope/errors/association_missing_error"

module AssociationScope
end

module ActiveRecord
  class Base
    def self.acts_as_association_scope(only: reflections.keys, except: [])
      # Apply given filters.
      # Don't be picky about singular or plural.
      raise ArgumentError, "Don't use :only and :except together!" unless only == reflections.keys || except == []

      only = only.map{|o| o.to_s}
      except = except.map{|e| e.to_s}

      ::AssociationScope::Scope.inject_scopes(self, only-except)
    end
  end
end
