# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    project_id { ULID.generate }
    token { SecureRandom.hex }
  end
end
