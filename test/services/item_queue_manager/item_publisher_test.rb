# frozen_string_literal: true

require 'test_helper'

class ItemQueueManager::ItemPublisherTest < ActiveSupport::TestCase
  test 'publishes the item to RabbitMQ' do
    project = build(:project)
    reported_item_attributes = {
      library: 'errmon.js',
      revision: 'v1.0.0',
      level: 'error',
      type: 'NoMethodError',
      message: 'undefined method `foo\' for nil:NilClass',
      stack_trace: 'app/models/user.rb:1:in `foo\'',
    }
    expected_event_payload = {
      project_id: project.project_id,
      data: reported_item_attributes,
    }

    result = ItemQueueManager::ItemPublisher.call(project, reported_item_attributes)

    assert_predicate result, :success?
    assert_published 'item.reported', expected_event_payload
  end

  test 'returns a failure object when payload is invalid' do
    project = build(:project)
    payload = {
      kind: 'NoMethodError',
      message: 123,
    }

    expected_errors = {
      library: ['deve estar presente'],
      revision: ['deve estar presente'],
      level: ['deve estar presente'],
      type: ['deve estar presente'],
      message: ['deve ser uma sequência de caracteres'],
      stack_trace: ['deve estar presente'],
    }

    result = ItemQueueManager::ItemPublisher.call(project, payload)

    assert_predicate result, :failure?
    assert_equal expected_errors, result.failure.errors.to_h
  end
end
