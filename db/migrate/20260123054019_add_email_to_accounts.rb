class AddEmailToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :email, :string
  end
end
