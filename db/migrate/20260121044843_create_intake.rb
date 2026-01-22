class CreateIntake < ActiveRecord::Migration[8.0]
  def change
    create_table :intakes do |t|
      t.string :name
      t.string :phone_number
      t.string :details
      t.string :urgency
      t.string :industry

      t.timestamps
    end
  end
end
