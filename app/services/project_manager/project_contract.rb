# frozen_string_literal: true

module ProjectManager
  class ProjectContract < Dry::Validation::Contract
    json do
      required(:project_id).filled(:string)
      required(:token).filled(:string)
    end
  end
end
