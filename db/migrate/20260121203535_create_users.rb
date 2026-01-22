class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :phone_number
      t.string :name
      t.string :details
      t.string :urgency
      t.string :industry
      t.string :string

      t.timestamps
    end
  end
end
