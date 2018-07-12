class SoftDeleteDiscard < ActiveRecord::Base
  if defined?(Discard::Model)
    include Discard::Model
    include CounterCulture::Hooks::Discard::ModelHooks
    default_scope -> { kept }
  end

  belongs_to :company
  counter_culture :company
end
