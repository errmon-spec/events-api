# frozen_string_literal: true

require 'test_helper'

class V1::IngressControllerTest < ActionDispatch::IntegrationTest
  test 'returns HTTP 202 when valid params' do
    project = create(:project)
    payload = {
      library: 'errmon.js',
      revision: 'v1.0.0',
      level: 'error',
      type: 'NoMethodError',
      message: 'undefined method `foo\' for nil:NilClass',
      stack_trace: 'app/models/user.rb:1:in `foo\'',
    }

    assert_enqueued project, payload do
      post v1_ingress_create_url, headers: authorization_headers(project), params: payload
    end

    assert_response :accepted
  end

  test 'returns HTTP 422 when missing required params' do
    project = create(:project)
    payload = {
      library: 'errmon.js',
      revision: 'v1.0.0',
      level: 'error',
      type: 'NoMethodError',
      stack_trace: 'app/models/user.rb:1:in `foo\'',
    }

    post v1_ingress_create_url, headers: authorization_headers(project), params: payload

    assert_response :unprocessable_entity
    assert_equal '{"errors":{"message":["is missing"]}}', @response.body
  end

  test 'returns HTTP 401 without credentials' do
    post v1_ingress_create_url

    assert_response :unauthorized
    assert_equal '{"error":"invalid project credentials"}', @response.body
  end

  test 'returns HTTP 401 with wrong credentials' do
    project = create(:project)

    post v1_ingress_create_url,
      headers: {
        'X-Errmon-Project-ID' => project.project_id,
        'X-Errmon-Project-Token' => 'wrong',
      }

    assert_response :unauthorized
    assert_equal '{"error":"invalid project credentials"}', @response.body
  end

  def assert_enqueued(project, payload, &)
    mock = Minitest::Mock.new
    mock.expect :call, nil, [{ project_id: project.project_id, data: payload }], content_type: 'application/json'

    Sneakers.stub(:publish, mock, &)

    assert_mock mock
  end
end
