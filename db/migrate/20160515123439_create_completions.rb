class CreateCompletions < ActiveRecord::Migration[5.0]
  def change
    create_table :completions do |t|
      t.references :quest, foreign_key: true

      t.timestamps
    end
  end
end
