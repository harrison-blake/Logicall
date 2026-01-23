class AddStaffNotesToIntakes < ActiveRecord::Migration[8.0]
  def change
    add_column :intakes, :staff_notes, :text
  end
end
