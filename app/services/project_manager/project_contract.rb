# frozen_string_literal: true

module ProjectManager
  class ProjectContract < ApplicationContract
    json do
      required(:project_id).filled(Types::StrippedString)
      required(:token).filled(Types::StrippedString)
    end
  end
end
