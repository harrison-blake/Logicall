class AddOnboardingFieldsToApplicants < ActiveRecord::Migration[8.0]
  def change
    add_column :applicants, :account_created, :boolean, default: false
    add_column :applicants, :documents_uploaded, :boolean, default: false
    add_column :applicants, :interview_scheduled, :boolean, default: false
  end
end
