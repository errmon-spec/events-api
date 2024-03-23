# frozen_string_literal: true

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  describe '.by_id_and_token' do
    test 'finds project by id and token' do
      expected_project = create(:project)
      project = Project.by_id_and_token(expected_project.project_id, expected_project.token).take

      assert_equal expected_project, project
    end

    test 'returns nil for invalid project id' do
      project = create(:project)

      assert_nil Project.by_id_and_token(ULID.generate, project.token).take
    end

    test 'returns nil for invalid token' do
      project = create(:project)

      assert_nil Project.by_id_and_token(project.project_id, 'invalid').take
    end
  end

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
