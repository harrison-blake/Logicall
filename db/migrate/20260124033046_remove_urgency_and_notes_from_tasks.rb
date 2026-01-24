class RemoveUrgencyAndNotesFromTasks < ActiveRecord::Migration[8.0]
  def change
    remove_column :tasks, :urgency, :string
    remove_column :tasks, :notes, :text
  end
end
