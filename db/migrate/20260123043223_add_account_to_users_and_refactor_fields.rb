class AddAccountToUsersAndRefactorFields < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :account, null: false, foreign_key: true
    add_column :users, :role, :string
    remove_column :users, :industry, :string
    remove_column :users, :phone_number, :string
  end
end
