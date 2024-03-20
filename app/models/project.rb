# frozen_string_literal: true

class Project < ApplicationRecord
  validates :project_id, :token, presence: true

  scope :by_id_and_token, ->id, token { where(project_id: id, token:) }
end
