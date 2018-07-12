require 'counter_culture/hooks/defaults'
require 'counter_culture/hooks/paranoia'
require 'counter_culture/hooks/discard'

module CounterCulture
  module Hooks

    MODULES = [
      CounterCulture::Hooks::Paranoia,
      CounterCulture::Hooks::Discard
    ]

    def self.before_destroy(model)
      MODULES.each { |mod| mod.before_destroy(model) }
    end

    def self.check_if_soft_deleted(model, target_table_alias)
      MODULES.inject(''){ |acc, mod| acc << mod.check_if_soft_deleted(model, target_table_alias) }
    end

  end
end
