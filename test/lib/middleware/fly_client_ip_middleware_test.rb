# frozen_string_literal: true

require 'test_helper'

class FlyClientIpMiddlewareTest < ActiveSupport::TestCase
  test 'sets the correct client IP' do
    app = ->_env { [200, {}, ['OK']] }

    env = {
      'HTTP_FLY_CLIENT_IP' => '246.129.91.255', # rubocop:disable Style/IpAddresses
      'HTTP_X_FORWARDED_FOR' => '13.93.94.164', # rubocop:disable Style/IpAddresses
    }

    expected_env = {
      'ORIGINAL_HTTP_X_FORWARDED_FOR' => '13.93.94.164', # rubocop:disable Style/IpAddresses
      'HTTP_X_FORWARDED_FOR' => '246.129.91.255', # rubocop:disable Style/IpAddresses
      'HTTP_FLY_CLIENT_IP' => '246.129.91.255', # rubocop:disable Style/IpAddresses
    }

    response = FlyClientIpMiddleware.new(app).call(env)

    assert_equal expected_env, env
    assert_equal [200, {}, ['OK']], response
  end
end
