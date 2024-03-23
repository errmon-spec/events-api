# frozen_string_literal: true

require 'test_helper'

class ItemQueueManagerTest < ActiveSupport::TestCase
  test 'calls ItemPublisher#call' do
    project = build(:project)
    payload = { type: 'NoMethodError', message: 'undefined method `foo\' for nil:NilClass' }

    assert_called ItemQueueManager::ItemPublisher, :call, project, payload do
      ItemQueueManager.add(project, payload)
    end
  end
end
