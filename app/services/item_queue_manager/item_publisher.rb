# frozen_string_literal: true

module ItemQueueManager
  class ItemPublisher
    include Dry::Monads[:result]

    def self.call(*)
      new(*).call
    end

    def initialize(project, payload, contract: ItemContract)
      @project = project
      @payload = payload
      @contract = contract
    end

    def call
      result = contract.call(payload)
      return Failure(result) if result.failure?

      event = {
        project_id: project.project_id,
        data: result.to_h,
      }

      RabbitPublisher.publish('item.reported', event)

      Success(event)
    end

    private

    attr_reader :project, :payload, :contract
  end
end
