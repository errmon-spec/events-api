# frozen_string_literal: true

require 'test_helper'

class ProjectManager::ProjectSyncTest < ActiveSupport::TestCase
  test 'creates a new project' do
    payload = { project_id: ULID.generate, token: SecureRandom.hex }

    result = ProjectManager.sync(payload)

    assert_predicate result, :success?

    project = Project.find(result.value!)

    assert_equal payload[:project_id], project.project_id
    assert_equal payload[:token], project.token
  end

  test 'updates an existing project' do
    existing_project = create(:project)
    new_token = SecureRandom.hex
    payload = { project_id: existing_project.project_id, token: new_token }

    assert_no_difference -> { Project.count } do
      ProjectManager.sync(payload)
    end

    assert_equal new_token, existing_project.reload.token
  end

  test 'fails when project_id is not present' do
    payload = { token: SecureRandom.hex }

    result = ProjectManager.sync(payload)

    assert_predicate result, :failure?
    assert_equal ['deve estar presente'], result.failure.errors[:project_id]
  end

  test 'fails when token is not present' do
    payload = { project_id: ULID.generate }

    result = ProjectManager.sync(payload)

    assert_predicate result, :failure?
    assert_equal ['deve estar presente'], result.failure.errors[:token]
  end
end
