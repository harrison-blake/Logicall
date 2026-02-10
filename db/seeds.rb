OnboardingStep.destroy_all
Applicant.destroy_all
DefaultOnboardingStep.destroy_all
Task.destroy_all
CallTranscript.destroy_all if defined?(CallTranscript)
Intake.destroy_all
AssistantLog.destroy_all if defined?(AssistantLog)
Account.update_all(default_intake_owner_id: nil)
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

# Default onboarding steps for the account
default_steps = [
  { title: "Complete W-4 form", position: 0 },
  { title: "Submit background check authorization", position: 1 },
  { title: "Upload nursing license", position: 2 },
  { title: "Complete HIPAA training", position: 3 },
  { title: "Set up direct deposit", position: 4 }
]

default_steps.each do |step|
  account.default_onboarding_steps.create!(step)
end

# Hiring candidates at different pipeline stages
candidates = [
  { name: "Sarah Chen", email: "sarah.chen@example.com", position: "Registered Nurse", status: :applied, notes: "5 years experience in pediatrics. Strong references from Children's Hospital." },
  { name: "Marcus Rivera", email: "marcus.r@example.com", position: "Medical Assistant", status: :applied, notes: "Recent graduate, certified MA. Bilingual English/Spanish." },
  { name: "Emily Watson", email: "emily.w@example.com", position: "Registered Nurse", status: :screening, notes: "10 years ICU experience. Relocating from Denver." },
  { name: "David Park", email: "david.park@example.com", position: "Front Desk Coordinator", status: :screening, notes: "3 years medical office experience. Excellent patient communication skills." },
  { name: "Rachel Foster", email: "rachel.f@example.com", position: "Nurse Practitioner", status: :interview, notes: "Board certified FNP. Interview scheduled for Monday." },
  { name: "James Mitchell", email: "james.m@example.com", position: "Medical Assistant", status: :interview, notes: "4 years urgent care experience. CPR and First Aid certified." },
  { name: "Angela Torres", email: "angela.t@example.com", position: "Registered Nurse", status: :offer, notes: "Offer letter sent — $85k salary. Awaiting response." },
  { name: "Kevin O'Brien", email: "kevin.ob@example.com", position: "Lab Technician", status: :hired, notes: "Start date: March 1. Onboarding in progress." },
  { name: "Lisa Nguyen", email: "lisa.n@example.com", position: "Registered Nurse", status: :hired, notes: "Started Feb 3. Completing orientation." },
  { name: "Tom Bradley", email: "tom.b@example.com", position: "Physical Therapist", status: :rejected, notes: "Credentials did not meet minimum requirements." }
]

candidates.each do |candidate_data|
  user = account.users.create!(
    name: candidate_data[:name],
    email: candidate_data[:email],
    password: "password",
    role: :applicant
  )

  applicant = user.create_applicant_profile!(
    position: candidate_data[:position],
    status: candidate_data[:status],
    notes: candidate_data[:notes]
  )

  # Add onboarding steps from defaults
  default_steps.each do |step|
    applicant.onboarding_steps.create!(title: step[:title], position: step[:position])
  end

  # Mark some onboarding steps as completed for hired candidates
  if candidate_data[:status] == :hired
    completed_count = candidate_data[:name] == "Lisa Nguyen" ? 4 : 2
    applicant.onboarding_steps.order(:position).limit(completed_count).update_all(completed: true)
  end
end
