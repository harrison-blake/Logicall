class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.references :intake, null: false, foreign_key: true
      t.string :subject
      t.integer :status

      t.timestamps
    end
  end
end
