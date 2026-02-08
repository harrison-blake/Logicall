class RemoveOnboardingBooleansFromApplicants < ActiveRecord::Migration[8.0]
  def change
    remove_column :applicants, :account_created, :boolean, default: false
    remove_column :applicants, :documents_uploaded, :boolean, default: false
    remove_column :applicants, :interview_scheduled, :boolean, default: false
  end
end
