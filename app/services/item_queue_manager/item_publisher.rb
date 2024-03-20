# frozen_string_literal: true

module ItemQueueManager
  class ItemPublisher
    include Dry::Monads[:result]

    def self.call(*)
      new(*).call
    end

    def initialize(payload, contract: ItemContract.new)
      @payload = payload
      @contract = contract
    end

    def call
      result = contract.call(payload)
      return Failure(result) if result.errors.present?

      Sneakers.publish(result.to_h, content_type: 'application/json')

      Success()
    end

    private

    attr_reader :payload, :contract
  end
end
