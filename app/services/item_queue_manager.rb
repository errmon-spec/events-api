# frozen_string_literal: true

module ItemQueueManager
  def self.add(payload)
    ItemPublisher.call(payload)
  end
end
