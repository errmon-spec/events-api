# frozen_string_literal: true

module ProjectManager
  class ProjectContract < ApplicationContract
    json do
      required(:project_id).filled(:string)
      required(:token).filled(:string)
    end
  end
end
