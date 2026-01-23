class AddStatusToIntakes < ActiveRecord::Migration[8.0]
  def change
    add_column :intakes, :status, :integer
  end
end
