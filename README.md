# LetsKonnect — Rails Monolith

A full-featured event management platform built with Ruby on Rails 7.1 and PostgreSQL.

## Portals

| Role | URL | Description |
|------|-----|-------------|
| Organizer | `/organizer/dashboard` | Manage events, tickets, agenda, check-in, analytics |
| Attendee  | `/attendee/dashboard`  | My events, badges, discover, networking |
| Admin     | `/admin/dashboard`     | Platform overview, tenants, subscriptions, support |

## Requirements

- Ruby >= 3.1
- PostgreSQL (running on localhost:5432)
- Bundler (`gem install bundler`)

## Quick start

```bash
# 1. Edit database credentials if needed
cp .env.example .env   # or just edit .env after setup creates it

# 2. One-command setup
bin/setup

# 3. Start the server
bin/dev           # Rails + Tailwind watcher (recommended)
# or
rails server      # Rails only (CSS already built)
```

Open http://localhost:3000 — click demo buttons on the login page.

**Demo accounts** (password: `demo1234`):
- `organizer@demo.letskonnect.app`
- `attendee@demo.letskonnect.app`
- `admin@demo.letskonnect.app`

## Database

Uses PostgreSQL. Connection configured via environment variables:

| Variable | Default |
|---|---|
| `DB_HOST` | `localhost` |
| `DB_PORT` | `5432` |
| `DB_USERNAME` | `postgres` |
| `DB_PASSWORD` | `postgres` |

Reset to fresh seed data: `rails db:drop db:create db:migrate db:seed`

## Stack

- **Framework**: Ruby on Rails 7.1 (monolithic, Hotwire)
- **Database**: PostgreSQL via `pg` gem
- **Auth**: `bcrypt` with custom session-based auth
- **Styles**: Tailwind CSS v3 (`tailwindcss-rails`)
- **Pagination**: `pagy`
