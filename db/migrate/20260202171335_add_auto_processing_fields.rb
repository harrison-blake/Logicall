class AddAutoProcessingFields < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :auto_process_transcripts, :boolean, default: false
    add_reference :accounts, :default_intake_owner, foreign_key: { to_table: :users }, null: true
    add_reference :call_transcripts, :intake, foreign_key: true, null: true
  end
end
