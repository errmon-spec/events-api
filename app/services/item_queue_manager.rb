# frozen_string_literal: true

module ItemQueueManager
  def self.add(project, payload)
    ItemPublisher.call(project, payload)
  end
end
