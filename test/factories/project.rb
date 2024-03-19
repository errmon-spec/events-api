# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    project_id { SecureRandom.uuid }
    token { SecureRandom.hex(20) }
  end
end
