# frozen_string_literal: true

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test 'should not save project without project_id' do
    project = Project.new

    assert_not project.save
    assert_includes project.errors.messages[:project_id], "can't be blank"
  end

  test 'should not save project without token' do
    project = Project.new

    assert_not project.save
    assert_includes project.errors.messages[:token], "can't be blank"
  end
end
