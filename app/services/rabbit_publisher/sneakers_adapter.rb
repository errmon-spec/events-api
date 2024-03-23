# frozen_string_literal: true

module RabbitPublisher
  class SneakersAdapter < AbstractAdapter
    def publish(routing_key, payload)
      Sneakers.publish(payload, routing_key:, content_type: 'application/json')
    end
  end
end
