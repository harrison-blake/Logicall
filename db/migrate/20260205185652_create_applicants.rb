class CreateApplicants < ActiveRecord::Migration[8.0]
  def change
    create_table :applicants do |t|
      t.string :position
      t.text :notes
      t.integer :status, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
