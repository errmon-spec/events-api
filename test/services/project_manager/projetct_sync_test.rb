# frozen_string_literal: true

require 'test_helper'

class ProjectManager::ProjectSyncTest < ActiveSupport::TestCase
  test 'creates a new project if it does not exist' do
    project_id = SecureRandom.uuid
    token = SecureRandom.hex(20)
    payload = { project_id:, token: }

    result_id =
      assert_difference -> { Project.count }, 1 do
        ProjectManager.sync(payload)
      end

    project = Project.find(result_id)

    assert_equal project_id, project.project_id
    assert_equal token, project.token
  end

  test 'updates the token of an existing project' do
    existing_project = create(:project)
    new_token = SecureRandom.hex(20)
    payload = { project_id: existing_project.project_id, token: new_token }

    assert_no_difference -> { Project.count } do
      ProjectManager.sync(payload)
    end

    assert_equal new_token, existing_project.reload.token
  end

  test 'raises InvalidProjectError if project_id is not present' do
    payload = { token: SecureRandom.hex(20) }

    assert_raises ProjectManager::InvalidProjectError do
      ProjectManager.sync(payload)
    end
  end

  test 'raises InvalidProjectError if token is not present' do
    payload = { project_id: SecureRandom.uuid }

    assert_raises ProjectManager::InvalidProjectError do
      ProjectManager.sync(payload)
    end
  end
end
