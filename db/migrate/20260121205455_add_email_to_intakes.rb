class AddEmailToIntakes < ActiveRecord::Migration[8.0]
  def change
    add_column :intakes, :email, :string
  end
end
