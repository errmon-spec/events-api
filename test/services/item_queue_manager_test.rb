# frozen_string_literal: true

require 'test_helper'

class ItemQueueManagerTest < ActiveSupport::TestCase
  test 'calls ItemPublisher#call' do
    payload = { type: 'NoMethodError', message: 'undefined method `foo\' for nil:NilClass' }

    mock = Minitest::Mock.new
    mock.expect :call, nil, [payload]

    ItemQueueManager::ItemPublisher.stub :call, mock do
      ItemQueueManager.add(payload)
    end

    assert_mock mock
  end
end
