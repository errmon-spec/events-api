# frozen_string_literal: true

require 'test_helper'

class ProjectManagerTest < ActiveSupport::TestCase
  test 'calls ProjectManager::ProjectSync.call' do
    payload = { project_id: SecureRandom.uuid, token: SecureRandom.hex(20) }
    mock = Minitest::Mock.new
    mock.expect :call, nil, [payload]
    ProjectManager::ProjectSync.stub :call, mock do
      ProjectManager.sync(payload)
    end
    mock.verify
  end
end
