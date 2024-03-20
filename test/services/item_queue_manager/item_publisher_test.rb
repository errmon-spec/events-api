# frozen_string_literal: true

require 'test_helper'

class ItemQueueManager::ItemPublisherTest < ActiveSupport::TestCase
  test 'publishes the item to RabbitMQ' do
    payload = {
      library: 'errmon.js',
      revision: 'v1.0.0',
      level: 'error',
      type: 'NoMethodError',
      message: 'undefined method `foo\' for nil:NilClass',
      stack_trace: 'app/models/user.rb:1:in `foo\'',
    }

    mock = Minitest::Mock.new
    mock.expect :call, nil, [payload], content_type: 'application/json'
    result =
      Sneakers.stub :publish, mock do
        ItemQueueManager::ItemPublisher.call(payload)
      end

    assert_predicate result, :success?
    assert_mock mock
  end

  test 'returns a failure object when payload is invalid' do
    payload = {
      kind: 'NoMethodError',
      message: 123,
    }

    expected_errors = {
      library: ['is missing'],
      revision: ['is missing'],
      level: ['is missing'],
      type: ['is missing'],
      message: ['must be a string'],
      stack_trace: ['is missing'],
    }

    result = ItemQueueManager::ItemPublisher.call(payload)

    assert_predicate result, :failure?
    assert_equal expected_errors, result.failure.errors.to_h # rubocop:disable Rails/DeprecatedActiveModelErrorsMethods
  end
end
