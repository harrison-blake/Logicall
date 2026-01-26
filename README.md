# Logicall README

A Ruby on Rails front office platform for professionals to streamline customers. Features account-based multi-tenancy with role-based user access. Allows Configuration of a phone number service for a custom AI receptionist with ElevenLabs. Chat with an admin AI agent that can complete customer intakes, send emails and various other features.  

## Requirements

- Ruby 3.4.1
- SQLite3

## Integrations

- **Twilio**: Phone number management for AI voice calls
- **ElevenLabs**: AI voice agent with post-call transcript webhooks
- **Gemini**: AI chat assistant on dashboard

## Frontend

- Hotwire (Turbo + Stimulus) for dynamic interactions
- Tailwind CSS v4
- ImportMap for JavaScript (no Node.js required)

## Setup

```bash
# Install dependencies
bundle install

# Setup database
bin/rails db:migrate
bin/rails db:seed

# Start development server
bin/dev
```
Or run components separately:

```bash
bin/rails server
bin/rails tailwindcss:watch
```

## Localhost with Webhooks
In order to test the Elevenlabs integration on dev, you'll need some sort of portforwarding mechanism to catch the webhook and direct it to localhost. I chose ngrok.
```bash
#install ngrok
brew install ngrok

#start ngrok on port 3000
ngrok http 3000

```

## Testing

```bash
bundle exec rspec                        # Run all tests
bundle exec rspec spec/models/user_spec.rb    # Single file
bundle exec rspec spec/models/user_spec.rb:10 # Single test at line
```


## Manual User Flows

**New Account**
1. Go to `/register`
2. Fill out form data and hit submit
3. Account with owner user is created and saved

**Add User to Account**
1. Login and go to `/dashboard`
2. Click `Add Staff` button
3. Fill out form data
4. Email is sent; user is created and saved

**Staff User Confirms Account**
1. Click link from email
2. Navigates to `/password_resets/:token/edit`
3. Fill in form with new password and hit submit
4. Login with email and new password navigates to `/dashboard`

**New Intake from Staff**
1. User is logged in
2. On dashboard click "New Patient Intake"
3. Enter form info
4. Intake is created and saved

**Create Task from Intake**
1. Go to intake edit page `/intakes/:id/edit`
2. Fill in text field and click add task

## Agent Flows

**Create Task from Intake**

**Phone Call to Transcription**

**Transcription to Intake**

## Dashboard View
<img width="951" height="774" alt="image" src="https://github.com/user-attachments/assets/6a5018bd-9290-4b4a-a137-c1baa64aa805" />
