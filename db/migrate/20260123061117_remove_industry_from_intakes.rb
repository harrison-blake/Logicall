class RemoveIndustryFromIntakes < ActiveRecord::Migration[8.0]
  def change
    remove_column :intakes, :industry, :string
  end
end
