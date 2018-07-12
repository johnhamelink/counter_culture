module CounterCulture
  module Hooks

    class Paranoia
      class << self
        include CounterCulture::Hooks::Defaults

        def before_destroy(model)
          if model.respond_to?(:paranoia_destroyed?)
            !model.paranoia_destroyed?
          else
            true
          end
        end

        def check_if_soft_deleted(model, target_table_alias)
          if model.respond_to?(:paranoia_column)
            " AND #{target_table_alias}.#{model.paranoia_column} IS NULL"
          else
            ''
          end
        end

      end

    end

  end
end
