# frozen_string_literal: true

require 'test_helper'

class FlyRequestIdMiddlewareTest < ActiveSupport::TestCase
  test 'falls back to HTTP_FLY_REQUEST_ID when HTTP_X_REQUEST_ID is not present' do
    env = { 'HTTP_X_REQUEST_ID' => '', 'HTTP_FLY_REQUEST_ID' => 'fly-123' }

    app = ->new_env { [200, new_env, ['OK']] }
    status, headers, body = FlyRequestIdMiddleware.new(app).call(env)

    assert_equal 'fly-123', headers['HTTP_X_REQUEST_ID']
    assert_equal 200, status
    assert_equal ['OK'], body
  end

  test 'does nothing when HTTP_X_REQUEST_ID is present' do
    env = { 'HTTP_X_REQUEST_ID' => 'existing-123', 'HTTP_FLY_REQUEST_ID' => 'fly-123' }

    app = ->new_env { [200, new_env, ['OK']] }
    status, headers, body = FlyRequestIdMiddleware.new(app).call(env)

    assert_equal 'existing-123', headers['HTTP_X_REQUEST_ID']
    assert_equal 200, status
    assert_equal ['OK'], body
  end
end
