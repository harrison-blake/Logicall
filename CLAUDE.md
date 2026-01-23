# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Logicall is a Ruby on Rails front office platform for healthcare professionals to streamline new patient intake. It features account-based multi-tenancy with role-based user access.

## Development Philosophy

"Everything should be made as simple as possible, but not simpler." Do the bare minimum that solves the task.

## Common Commands

```bash
# Start development server (runs Rails + Tailwind CSS watcher)
bin/dev

# Or run components separately
bin/rails server
bin/rails tailwindcss:watch

# Database
bin/rails db:migrate
bin/rails db:seed              # Creates default account with owner user

# Testing
bin/rails test                 # Run all tests
bin/rails test test/models/user_test.rb           # Single test file
bin/rails test test/models/user_test.rb:10        # Single test at line

# Code quality
bin/rubocop                    # Lint with Rails Omakase style
bin/brakeman                   # Security vulnerability scan
```

## Architecture

### Authentication System

Session-based authentication without a gem:
- `ApplicationController#current_user` - helper method available in views/controllers
- `ApplicationController#require_authentication` - before_action filter for protected routes
- Session stored in `session[:current_user_id]`
- Passwords hashed with bcrypt via `has_secure_password`

### Data Model

```
Account (company/organization)
├── has_many :users
└── fields: company_name, industry, phone_number, email

User (belongs_to Account)
├── roles: owner (0), admin (1), default (2)
└── fields: email, name, password_digest, role

Intake (patient intake form - not yet linked to accounts)
└── fields: name, phone_number, email, details, urgency
```

### Route Structure

- `/` - Public landing page
- `/accounts/new` → `/accounts/:id/users/new` - Registration flow (account then user)
- `/login`, `/logout` - Session management
- `/dashboard` - Protected, requires authentication
- `/intakes/new` - Patient intake form

### Frontend Stack

- Hotwire (Turbo + Stimulus) for dynamic interactions
- Tailwind CSS v4 via tailwindcss-rails
- ImportMap for JavaScript modules (no Node.js/npm)
