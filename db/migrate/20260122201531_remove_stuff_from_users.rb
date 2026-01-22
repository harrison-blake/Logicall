class RemoveStuffFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :details, :string
    remove_column :users, :urgency, :string
    remove_column :users, :string, :string
  end
end
