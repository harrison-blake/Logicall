class CreateActions < ActiveRecord::Migration[8.0]
  def change
    create_table :actions do |t|
      t.references :task, null: false, foreign_key: true
      t.string :description
      t.boolean :completed, default: false, null: false

      t.timestamps
    end
  end
end
