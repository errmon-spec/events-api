# frozen_string_literal: true

require 'test_helper'

class ProjectManagerTest < ActiveSupport::TestCase
  test 'calls ProjectSync#call' do
    payload = { project_id: ULID.generate, token: SecureRandom.hex }

    assert_called ProjectManager::ProjectSync, :call, payload do
      ProjectManager.sync(payload)
    end
  end
end
