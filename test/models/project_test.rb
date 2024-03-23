# frozen_string_literal: true

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  describe '.by_id_and_token' do
    test 'returns project when valid id and token are provided' do
      expected_project = create(:project)
      project = Project.by_id_and_token(expected_project.project_id, expected_project.token).take

      assert_equal expected_project, project
    end

    test 'returns nil when project id does not exist' do
      project = create(:project)

      assert_nil Project.by_id_and_token(ULID.generate, project.token).take
    end

    test 'returns nil when token is invalid' do
      project = create(:project)

      assert_nil Project.by_id_and_token(project.project_id, SecureRandom.hex).take
    end
  end

  test 'validates presence of project_id' do
    project = Project.new

    assert_not project.save
    assert_includes project.errors.messages[:project_id], 'não pode ficar em branco'
  end

  test 'validates uniqueness of project_id' do
    existing_project = create(:project)
    project = Project.new(project_id: existing_project.project_id)

    assert_not project.save
    assert_includes project.errors.messages[:project_id], 'já está em uso'
  end

  test 'validates presence of token' do
    project = Project.new

    assert_not project.save
    assert_includes project.errors.messages[:token], 'não pode ficar em branco'
  end
end
