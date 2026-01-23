# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

account = Account.find_or_create_by!(company_name: "Test Company") do |a|
  a.industry = "Healthcare"
  a.phone_number = "555-123-4567"
  a.email = "contact@testcompany.com"
end

User.find_or_create_by!(email: "owner@test.com") do |u|
  u.name = "Test Owner"
  u.password = "password"
  u.account = account
  u.role = :owner
end

intake1 = Intake.find_or_create_by!(name: "John Smith", email: "john.smith@example.com") do |i|
  i.phone_number = "555-111-2222"
  i.details = "New patient requesting initial consultation for chronic back pain"
  i.urgency = "medium"
  i.status = :reviewed
end

intake2 = Intake.find_or_create_by!(name: "Sarah Johnson", email: "sarah.j@example.com") do |i|
  i.phone_number = "555-333-4444"
  i.details = "Follow-up appointment needed for medication review"
  i.urgency = "low"
  i.status = :reviewed
end

intake3 = Intake.find_or_create_by!(name: "Mike Davis", email: "mike.davis@example.com") do |i|
  i.phone_number = "555-555-6666"
  i.details = "Urgent referral from ER for post-surgical care"
  i.urgency = "high"
  i.status = :reviewed
end

Intake.find_or_create_by!(name: "Emily Chen", email: "emily.chen@example.com") do |i|
  i.phone_number = "555-777-8888"
  i.details = "New patient inquiry about physical therapy options"
  i.status = :pending
end

Intake.find_or_create_by!(name: "Robert Williams", email: "r.williams@example.com") do |i|
  i.phone_number = "555-999-0000"
  i.details = "Requesting information about treatment plans for diabetes management"
  i.status = :pending
end

Task.find_or_create_by!(intake: intake1, subject: "Verify insurance information") do |t|
  t.status = :pending
end

Task.find_or_create_by!(intake: intake1, subject: "Schedule initial consultation") do |t|
  t.status = :pending
end

Task.find_or_create_by!(intake: intake2, subject: "Request medical records from previous provider") do |t|
  t.status = :pending
end

Task.find_or_create_by!(intake: intake3, subject: "Contact ER for discharge summary") do |t|
  t.status = :pending
end

Task.find_or_create_by!(intake: intake3, subject: "Arrange urgent appointment slot") do |t|
  t.status = :pending
end
