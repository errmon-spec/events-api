# frozen_string_literal: true

module ProjectAuthenticatable
  extend ActiveSupport::Concern

  class InvalidProjectCredentialsError < StandardError
  end

  included do
    prepend_before_action :authenticate_project!

    rescue_from InvalidProjectCredentialsError do
      render json: { error: 'invalid project credentials' }, status: :unauthorized
    end
  end

  private

  def append_info_to_payload(payload)
    super
    payload[:project_id] = project_id if project_id
  end

  def authenticate_project!
    raise InvalidProjectCredentialsError if current_project.blank?
  end

  def current_project
    return if project_id.blank? || project_token.blank?

    @_current_project ||= Project.by_id_and_token(project_id, project_token).take
  end

  def project_id
    request.headers['X-Errmon-Project-ID']
  end

  def project_token
    request.headers['X-Errmon-Project-Token']
  end
end
