Task.destroy_all
Intake.destroy_all
User.destroy_all
Account.destroy_all

account = Account.create!(
  company_name: "Test Company",
  industry: "Healthcare",
  phone_number: "555-123-4567",
  email: "contact@testcompany.com"
)

owner = User.create!(
  name: "Test Owner",
  email: "owner@test.com",
  password: "password",
  account: account,
  role: :owner
)

intake1 = owner.intakes.create!(
  name: "John Smith",
  email: "john.smith@example.com",
  phone_number: "555-111-2222",
  details: "New patient requesting initial consultation for chronic back pain",
  urgency: "high",
  status: :pending
)

intake2 = owner.intakes.create!(
  name: "Jane Doe",
  email: "jane.doe@example.com",
  phone_number: "555-333-4444",
  details: "Follow-up appointment for annual checkup",
  urgency: "low",
  status: :pending
)

intake3 = owner.intakes.create!(
  name: "Bob Wilson",
  email: "bob.wilson@example.com",
  phone_number: "555-555-6666",
  details: "Referred by Dr. Adams for specialist consultation",
  urgency: "medium",
  status: :reviewed
)

intake1.tasks.create!(subject: "Verify insurance coverage", status: :pending)
intake1.tasks.create!(subject: "Request medical records", status: :pending)
intake2.tasks.create!(subject: "Send appointment confirmation", status: :completed)
intake3.tasks.create!(subject: "Schedule follow-up call", status: :completed)
