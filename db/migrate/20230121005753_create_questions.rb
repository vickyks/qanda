# frozen_string_literal: true

class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.text :text
      t.references :user, null: false, foreign_key: true
      t.integer :answer_count

      t.timestamps
    end
  end
end
