# frozen_string_literal: true

module AuthenticationTestHelpers
  def authorization_headers(project)
    {
      'X-Errmon-Project-ID' => project.project_id,
      'X-Errmon-Project-Token' => project.token,
    }
  end
end

class ActionDispatch::IntegrationTest # rubocop:disable Style/ClassAndModuleChildren
  include AuthenticationTestHelpers
end
