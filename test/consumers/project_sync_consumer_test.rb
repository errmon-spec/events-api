# frozen_string_literal: true

require 'test_helper'

class ProjectSyncConsumerTest < ActiveSupport::TestCase
  test 'calls ProjectManager.sync' do
    consumer = ProjectSyncConsumer.new
    payload = { project_id: ULID.generate, token: SecureRandom.hex }

    assert_called ProjectManager, :sync, payload, and_return: Success.new(1) do
      consumer.work(payload)
    end
  end

  test 'acks when project sync operation succeeds' do
    consumer = ProjectSyncConsumer.new
    payload = { project_id: ULID.generate, token: SecureRandom.hex }

    mock_call ProjectManager, :sync, payload, and_return: Success.new(1) do
      assert_equal :ack, consumer.work(payload)
    end
  end

  test 'rejects when project sync operation fails' do
    consumer = ProjectSyncConsumer.new
    payload = { project_id: ULID.generate, token: SecureRandom.hex }

    mock_call ProjectManager, :sync, payload, and_return: Failure.new(1) do
      assert_equal :reject, consumer.work(payload)
    end
  end
end
