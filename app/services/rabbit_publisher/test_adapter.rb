# frozen_string_literal: true

module RabbitPublisher
  class TestAdapter < AbstractAdapter
    include Singleton

    def initialize
      @events = Hash.new { |hash, key| hash[key] = [] }
    end

    def publish(routing_key, payload)
      @events[routing_key] << payload
    end

    def events_by_routing_key(routing_key)
      @events[routing_key]
    end

    def clear
      @events.clear
    end
  end
end
