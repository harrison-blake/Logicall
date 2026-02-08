# Logicall Onboarding Flow

## 1. Staff creates applicant
**Who:** Staff / Admin
**Where:** `/applicants/new`
- Enters candidate name, email, and position
- System creates a user account with `applicant` role and generates a temporary password
- Applicant starts in `applied` status

## 2. Staff moves applicant through pipeline
**Who:** Staff / Admin
**Where:** `/applicants` (Kanban board)
- Drags applicant card between stages: Applied → Screening → Interview → Offer → Hired / Rejected
- Pipeline reflects current status visible to both staff and applicant

## 3. Staff adds onboarding steps
**Who:** Staff / Admin
**Where:** `/applicants/:id/edit`
- Adds custom checklist items for the applicant (e.g., "Submit W-4", "Complete HIPAA training", "Sign NDA")
- Can add, remove, or reorder steps at any time

## 4. Applicant logs in
**Who:** Applicant
**Where:** `/login`
- Logs in with email and temporary password
- Redirected to applicant portal

## 5. Applicant views their status and checklist
**Who:** Applicant
**Where:** `/applicant_portal`
- Sees current pipeline status (e.g., "Screening", "Offer")
- Sees onboarding checklist with completion state (read-only)

## 6. Staff marks onboarding steps complete
**Who:** Staff / Admin
**Where:** `/applicants/:id/edit`
- Toggles steps as completed when applicant fulfills them
- Progress bar updates automatically
- Applicant sees updated status on their portal

## 7. Staff updates applicant details
**Who:** Staff / Admin
**Where:** `/applicants/:id/edit`
- Updates position, internal notes, or status as needed throughout the process
