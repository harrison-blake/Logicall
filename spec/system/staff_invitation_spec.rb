require "rails_helper"

RSpec.describe "Staff Invitation", type: :system do
  include ActiveJob::TestHelper

  let(:account) { Account.create!(company_name: "Test Company", industry: "Healthcare") }
  let(:owner) { User.create!(name: "Owner", email: "owner@example.com", password: "password", account: account, role: :owner) }

  before do
    driven_by :rack_test
    ActionMailer::Base.deliveries.clear
  end

  it "sends invitation email when owner adds staff member" do
    perform_enqueued_jobs do
      visit login_path
      fill_in "Email", with: owner.email
      fill_in "Password", with: "password"
      click_button "Log In"

      click_link "New Staff"
      fill_in "Name", with: "Jane Doe"
      fill_in "Email", with: "jane@example.com"
      click_button "Add Staff Member"

      expect(page).to have_content("Staff member added and invitation sent")

      staff = User.find_by(email: "jane@example.com")
      expect(staff).to be_present
      expect(staff.role).to eq("staff")

      expect(ActionMailer::Base.deliveries.size).to eq(1)
      email = ActionMailer::Base.deliveries.last
      expect(email.to).to include("jane@example.com")
      expect(email.subject).to include("invited to join Test Company")
    end
  end

  it "allows staff to set password via invitation link" do
    # Create staff member directly
    staff = User.create!(
      name: "Jane Doe",
      email: "jane@example.com",
      password: SecureRandom.hex(16),
      account: account,
      role: :staff
    )
    original_password_digest = staff.password_digest
    reset_token = staff.password_reset_token

    # Visit password reset link
    visit edit_password_reset_path(token: reset_token)

    # Set new password
    fill_in "New Password", with: "newpassword123"
    fill_in "Confirm Password", with: "newpassword123"
    click_button "Set Password"

    # Verify redirect to dashboard and logged in
    expect(page).to have_content("Password set successfully")
    expect(page).to have_current_path(dashboard_path)

    # Verify password was changed
    staff.reload
    expect(staff.password_digest).not_to eq(original_password_digest)
    expect(staff.authenticate("newpassword123")).to be_truthy
  end
end
