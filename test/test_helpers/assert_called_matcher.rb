# frozen_string_literal: true

module AssertCalledMatcher
  def assert_called(klass, method, *args, **kargs, &)
    mock = Minitest::Mock.new
    mock.expect :call, nil, [*args], **kargs

    klass.stub(method, mock, &)

    assert_mock mock
  end
end

class ActiveSupport::TestCase # rubocop:disable Style/ClassAndModuleChildren
  include AssertCalledMatcher
end
