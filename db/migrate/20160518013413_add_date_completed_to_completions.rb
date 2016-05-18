class AddDateCompletedToCompletions < ActiveRecord::Migration[5.0]
  def change
    add_column :completions, :date_completed, :date
  end
end
