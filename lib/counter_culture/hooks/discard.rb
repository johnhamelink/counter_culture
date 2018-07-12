module CounterCulture
  module Hooks
    module Discard

      module ModelHooks
        def self.included(model)
          if defined?(::Discard::Model) && model.include?(::Discard::Model)
            model.before_discard :_update_counts_after_destroy,
                          if: ->(model) { !model.discarded? }

            model.before_undiscard :_update_counts_after_create,
                            if: ->(model) { model.discarded? }
          end
        end
      end

      class << self
        include CounterCulture::Hooks::Defaults

        def check_if_soft_deleted(model, target_table_alias)
          # respect the discard column if it exists
          if defined?(::Discard::Model) &&
             model.include?(::Discard::Model) &&
             model.column_names.include?(model.discard_column.to_s)

            " AND #{target_table_alias}.#{model.discard_column} IS NULL"
          else
            ''
          end
        end
      end

    end
  end
end
