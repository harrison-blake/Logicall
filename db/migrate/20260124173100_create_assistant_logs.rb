class CreateAssistantLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :assistant_logs do |t|
      t.string :action_type
      t.text :details
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
