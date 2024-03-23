# frozen_string_literal: true

class Project < ApplicationRecord
  scope :by_id_and_token, ->id, token { where(project_id: id, token:) }

  validates :project_id, :token, presence: true
  validates :project_id, uniqueness: true
end
