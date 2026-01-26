class CreateCallTranscripts < ActiveRecord::Migration[8.0]
  def change
    create_table :call_transcripts do |t|
      t.references :account, null: false, foreign_key: true
      t.string :conversation_id
      t.string :caller_phone
      t.text :transcript
      t.integer :call_duration
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
