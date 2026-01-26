class AddTwilioPhoneNumberToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :twilio_phone_number, :string
    add_index :accounts, :twilio_phone_number, unique: true
  end
end
