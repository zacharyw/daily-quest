class CreateQuests < ActiveRecord::Migration[5.0]
  def change
    create_table :quests do |t|
      t.references :user, foreign_key: true
      t.text :description
      t.integer :goal
      t.text :reward
      t.boolean :complete

      t.timestamps
    end
  end
end
