class AddTelnyxPhoneNumberToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :telnyx_phone_number, :string
    add_index :accounts, :telnyx_phone_number, unique: true
  end
end
