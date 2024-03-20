# frozen_string_literal: true

require 'test_helper'

class ProjectSyncConsumerTest < ActiveSupport::TestCase
  test 'calls ProjectManager.sync' do
    consumer = ProjectSyncConsumer.new
    payload = { project_id: SecureRandom.uuid, token: SecureRandom.hex(20) }

    mock = Minitest::Mock.new
    mock.expect :call, nil, [payload]

    ProjectManager.stub :sync, mock do
      consumer.work(payload)
    end

    assert_mock mock
  end

  test 'acks' do
    consumer = ProjectSyncConsumer.new
    payload = { project_id: SecureRandom.uuid, token: SecureRandom.hex(20) }

    mock = Minitest::Mock.new
    mock.expect :call, nil, [payload]

    ProjectManager.stub :sync, mock do
      assert_equal :ack, consumer.work(payload)
    end
  end
end
