# frozen_string_literal: true

require 'test_helper'

class ProjectSyncConsumerTest < ActiveSupport::TestCase
  test 'calls ProjectManager.sync' do
    consumer = ProjectSyncConsumer.new
    payload = { project_id: ULID.generate, token: SecureRandom.hex }

    assert_called ProjectManager, :sync, payload do
      consumer.work(payload)
    end
  end

  test 'acks' do
    consumer = ProjectSyncConsumer.new
    payload = { project_id: ULID.generate, token: SecureRandom.hex }

    mock_call ProjectManager, :sync, payload do
      assert_equal :ack, consumer.work(payload)
    end
  end
end
