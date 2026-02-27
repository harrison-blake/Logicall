class AddApiKeysToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :gemini_api_key, :string
    add_column :accounts, :telnyx_api_key, :string
  end
end
