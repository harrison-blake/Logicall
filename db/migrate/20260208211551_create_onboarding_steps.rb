class CreateOnboardingSteps < ActiveRecord::Migration[8.0]
  def change
    create_table :onboarding_steps do |t|
      t.references :applicant, null: false, foreign_key: true
      t.string :title
      t.boolean :completed, default: false
      t.integer :position, default: 0

      t.timestamps
    end
  end
end
