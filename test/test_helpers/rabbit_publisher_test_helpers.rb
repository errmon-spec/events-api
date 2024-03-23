# frozen_string_literal: true

module RabbitPublisherTestHelpers
  def before_setup
    RabbitPublisher::TestAdapter.instance.clear
    super
  end

  def assert_published(routing_key, expected_event)
    events = RabbitPublisher::TestAdapter.instance.events_by_routing_key(routing_key)

    assert_equal [expected_event], events
  end
end

class ActiveSupport::TestCase # rubocop:disable Style/ClassAndModuleChildren
  include RabbitPublisherTestHelpers
end
