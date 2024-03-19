# frozen_string_literal: true

module ProjectManager
  class ProjectSync
    def self.call(*)
      new(*).call
    end

    def initialize(payload, contract: ProjectContract.new)
      @payload = payload
      @contract = contract
    end

    def call
      result = contract.call(payload)
      raise InvalidProjectError.new('Invalid project', result) if result.errors.present?

      normalized_payload = result.to_h

      upsert_result = Project.upsert( # rubocop:disable Rails/SkipsModelValidations
        { project_id: normalized_payload[:project_id], token: normalized_payload[:token] },
        unique_by: :project_id,
        update_only: [:token],
        record_timestamps: true,
      )

      upsert_result.first['id']
    end

    private

    attr_reader :payload, :contract
  end
end
