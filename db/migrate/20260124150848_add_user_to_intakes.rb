class AddUserToIntakes < ActiveRecord::Migration[8.0]
  def change
    add_reference :intakes, :user, foreign_key: true
  end
end
