# frozen_string_literal: true

module ItemQueueManager
  class ItemContract < ApplicationContract
    ITEM_LEVELS = %w[debug info warning error critical].freeze

    json do
      required(:library).filled(Types::StrippedString)
      required(:revision).filled(Types::StrippedString)
      required(:level).filled(included_in?: ITEM_LEVELS)
      required(:type).filled(Types::StrippedString)
      required(:message).filled(Types::StrippedString)
      required(:stack_trace).filled(:string)
    end
  end
end
