# frozen_string_literal: true

class EnableExtensionUlid < ActiveRecord::Migration[7.1]
  def change
    enable_extension 'ulid' unless extension_enabled?('ulid')
  end
end
