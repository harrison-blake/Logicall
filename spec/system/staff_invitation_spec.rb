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
    expect(staff.password_reset_token).to be_present

    expect(ActionMailer::Base.deliveries.size).to eq(1)
    email = ActionMailer::Base.deliveries.last
    expect(email.to).to include("jane@example.com")
    expect(email.subject).to include("invited to join Test Company")
    end
  end
end
