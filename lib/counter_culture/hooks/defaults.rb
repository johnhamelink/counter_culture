module CounterCulture
  module Hooks
    module Defaults

      def before_destroy(model)
        true
      end

      def check_if_soft_deleted(model, target_table_alias)
        ''
      end

    end
  end
end
