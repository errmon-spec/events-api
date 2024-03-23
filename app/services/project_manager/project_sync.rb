# frozen_string_literal: true

module ProjectManager
  class ProjectSync
    include Dry::Monads[:result]

    def self.call(*)
      new(*).call
    end

    def initialize(payload, contract: ProjectContract)
      @payload = payload
      @contract = contract
    end

    def call
      result = contract.call(payload)
      return Failure(result) if result.failure?

      normalized_payload = result.to_h

      upsert_result = Project.upsert( # rubocop:disable Rails/SkipsModelValidations
        { project_id: normalized_payload[:project_id], token: normalized_payload[:token] },
        unique_by: :project_id,
        update_only: [:token],
        record_timestamps: true,
      )

      Success(upsert_result.first['id'])
    end

    private

    attr_reader :payload, :contract
  end
end
