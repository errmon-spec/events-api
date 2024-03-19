# frozen_string_literal: true

class Project < ApplicationRecord
  validates :project_id, :token, presence: true
end
