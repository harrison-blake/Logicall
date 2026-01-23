class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :industry
      t.string :company_name
      t.string :phone_number

      t.timestamps
    end
  end
end
