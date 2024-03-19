# frozen_string_literal: true

module ProjectManager
  def self.sync(payload)
    ProjectSync.call(payload)
  end
end
