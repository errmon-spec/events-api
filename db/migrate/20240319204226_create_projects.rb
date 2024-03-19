# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.string :project_id, null: false
      t.string :token, null: false

      t.timestamps
    end

    add_index :projects, :project_id, unique: true
  end
end
