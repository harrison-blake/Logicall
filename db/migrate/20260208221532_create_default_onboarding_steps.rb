class CreateDefaultOnboardingSteps < ActiveRecord::Migration[8.0]
  def change
    create_table :default_onboarding_steps do |t|
      t.references :account, null: false, foreign_key: true
      t.string :title, null: false
      t.integer :position, default: 0

      t.timestamps
    end
  end
end
