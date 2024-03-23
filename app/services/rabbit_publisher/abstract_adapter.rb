# frozen_string_literal: true

module RabbitPublisher
  class AbstractAdapter
    def publish(routing_key, payload)
      raise NotImplementedError
    end
  end
end
