# frozen_string_literal: true

module AssertCalledMatcher
  def mock_call(klass, method, *args, and_return: nil, **kargs, &)
    mock = Minitest::Mock.new
    mock.expect :call, and_return, [*args], **kargs

    klass.stub(method, mock, &)

    mock
  end

  def assert_called(...)
    mock = mock_call(...)

    assert_mock mock
  end
end

class ActiveSupport::TestCase # rubocop:disable Style/ClassAndModuleChildren
  include AssertCalledMatcher
end
