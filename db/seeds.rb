require "bcrypt"

puts "Seeding LetsKonnect..."

# ── helpers ──────────────────────────────────────────────────────────────────
def uid  = SecureRandom.alphanumeric(12)
def tcode = "LK-#{SecureRandom.alphanumeric(4).upcase}-#{SecureRandom.alphanumeric(4).upcase}"
def slugify(s) = s.downcase.strip.gsub(/[^a-z0-9]+/, "-").gsub(/(^-|-$)/, "")

pw = BCrypt::Password.create("demo1234")

# ── Users ─────────────────────────────────────────────────────────────────────
organizer = User.find_or_create_by!(email: "organizer@demo.letskonnect.app") do |u|
  u.id            = uid
  u.name          = "Alex Morgan"
  u.password_digest = pw
  u.role          = "organizer"
  u.title         = "Head of Events"
  u.company       = "FutureStack Inc."
  u.interests     = "Ops, AV production"
end

attendee = User.find_or_create_by!(email: "attendee@demo.letskonnect.app") do |u|
  u.id            = uid
  u.name          = "Alex Morgan"   # same name per screenshots
  u.password_digest = pw
  u.role          = "attendee"
  u.title         = "Product Manager"
  u.company       = "Northwind Labs"
  u.interests     = "AI, DevTools, Climate"
end

admin = User.find_or_create_by!(email: "admin@demo.letskonnect.app") do |u|
  u.id            = uid
  u.name          = "Alex Morgan"
  u.password_digest = pw
  u.role          = "admin"
  u.title         = "Platform Ops"
  u.company       = "LetsKonnect"
end

extras = [
  ["Lena Fischer",    "lena@demo.letskonnect.app",    "Design Lead",         "Mosaic",        "Design systems, Accessibility"],
  ["Tom Okafor",      "tom@demo.letskonnect.app",     "CTO",                 "Driftline",     "Infra, Rust, Edge"],
  ["Mei Tan",         "mei@demo.letskonnect.app",     "Founder",             "Pollen",        "Fundraising, Community"],
  ["Diego Alvarez",   "diego@demo.letskonnect.app",   "ML Engineer",         "Vesper AI",     "LLMs, Eval, Agents"],
  ["Hana Sato",       "hana@demo.letskonnect.app",    "Marketing Director",  "Brightwave",    "Growth, Events"],
  ["Ravi Krishnan",   "ravi@demo.letskonnect.app",    "Solutions Architect", "CloudPier",     "Kubernetes, FinOps"],
].map do |name, email, title, company, interests|
  User.find_or_create_by!(email: email) do |u|
    u.id = uid; u.name = name; u.password_digest = pw
    u.role = "attendee"; u.title = title; u.company = company; u.interests = interests
  end
end

# ── Tenants (for Admin portal) ─────────────────────────────────────────────
tenants_data = [
  ["FutureStack Inc.",   "enterprise", 490000, "ops@futurestack.io",     "2024-02-11"],
  ["Northwind Events",   "growth",     149000, "hello@northwind.events", "2024-06-03"],
  ["Helix Summit Co.",   "growth",          0, "billing@helix.co",       "2026-05-20"],
  ["Brightline Expos",   "enterprise", 820000, "admin@brightline.co",    "2023-09-17"],
  ["Lumen Networking",   "starter",     29000, "hi@lumennetwork.com",    "2025-11-02"],
]
tenants = tenants_data.map do |name, plan, monthly_cents, billing_email, joined|
  Tenant.find_or_create_by!(name: name) do |t|
    t.id = uid; t.plan = plan; t.monthly_cents = monthly_cents
    t.billing_email = billing_email; t.joined_on = joined; t.status = "active"
  end
end

# ── Support tickets ─────────────────────────────────────────────────────────
[
  [tenants[0].id, "SSO callback failing for staff role",          "high",   "ops@futurestack.io"],
  [tenants[3].id, "Bulk import of 12k registrations timing out",  "urgent", "admin@brightline.co"],
  [tenants[1].id, "Customize check-in confirmation email",        "normal", "hello@northwind.events"],
  [tenants[4].id, "Reactivate suspended workspace",               "high",   "billing@atlasconf.com"],
].each do |tid, subject, priority, submitted_by|
  SupportTicket.find_or_create_by!(subject: subject) do |st|
    st.id = uid; st.tenant_id = tid; st.priority = priority
    st.submitted_by = submitted_by; st.status = "open"
  end
end

# ── Events ────────────────────────────────────────────────────────────────────
events_data = [
  {
    name: "FutureStack 2026",
    slug: "futurestack-2026",
    type: "Conference",
    tagline: "Where the modern stack gets built.",
    description: "Three days of keynotes, deep-dive workshops and an expo floor covering AI infrastructure, developer tooling and the future of software teams.",
    location: "Moscone West, San Francisco, CA",
    start: "2026-09-14", end: "2026-09-16",
    status: "published",
    hero: "https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=1600&auto=format",
    capacity: 3000,
    tiers: [
      {name: "Early Bird", price: 49900, qty: 300},
      {name: "Regular",    price: 79900, qty: 1500},
      {name: "VIP",        price: 149900, qty: 100},
      {name: "Student",    price: 9900,  qty: 200},
    ],
    speakers: [
      {name: "Maya Chen",   title: "VP Engineering",   company: "Lattice"},
      {name: "Jonas Wirth", title: "Principal Engineer", company: "Vercel"},
      {name: "Aisha Bello", title: "Head of AI",        company: "Stripe"},
    ],
    sessions: [
      {title: "Opening keynote: The stack in 2030", track: "Main stage", kind: "Keynote",    starts: "2026-09-14T09:30", ends: "2026-09-14T10:15", room: "Hall A", speaker_idx: 0},
      {title: "Edge rendering at scale",            track: "Infrastructure", kind: "Talk",    starts: "2026-09-14T11:00", ends: "2026-09-14T11:45", room: "Hall B", speaker_idx: 1},
      {title: "Evaluating LLM features",            track: "AI",          kind: "Workshop",   starts: "2026-09-14T14:00", ends: "2026-09-14T16:00", room: "Workshop 2", speaker_idx: 2},
      {title: "AI matchmaking hour",                track: "Networking",  kind: "Networking", starts: "2026-09-15T17:00", ends: "2026-09-15T18:00", room: "Expo floor", speaker_idx: nil},
    ]
  },
  {
    name: "Northstar Product Summit",
    slug: "northstar-summit",
    type: "Summit",
    tagline: "One day. Every product leader you want in the room.",
    description: "A single-track summit for heads of product: roadmaps, discovery, pricing and the craft of saying no.",
    location: "Barbican Centre, London, UK",
    start: "2026-05-22", end: "2026-05-22",
    status: "published",
    hero: "https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=1600&auto=format",
    capacity: 200,
    tiers: [
      {name: "Regular", price: 35000, qty: 178},
      {name: "VIP",     price: 75000, qty: 22},
    ],
    speakers: [{name: "Ed Park", title: "CPO", company: "Linear"}],
    sessions: [
      {title: "Saying no: roadmap as strategy", track: "Main stage", kind: "Keynote", starts: "2026-05-22T10:00", ends: "2026-05-22T10:45", room: "Auditorium", speaker_idx: 0},
    ]
  },
  {
    name: "DesignWeek Berlin",
    slug: "designweek-berlin",
    type: "Exhibition",
    tagline: "Five days of craft, type and tools.",
    description: "An exhibition-format week with studio open houses, portfolio reviews and an exhibitor hall of 80+ design tool makers.",
    location: "Station Berlin, Berlin, DE",
    start: "2026-06-08", end: "2026-06-12",
    status: "draft",
    hero: "https://images.unsplash.com/photo-1559136555-9303baea8ebd?w=1600&auto=format",
    capacity: 5000,
    tiers: [
      {name: "Free Expo Pass", price: 0, qty: 5000},
      {name: "Pro Pass",       price: 19900, qty: 800},
    ],
    speakers: [],
    sessions: []
  },
]

created_events = events_data.map do |ed|
  ev = Event.find_or_create_by!(slug: ed[:slug]) do |e|
    e.id = uid; e.organizer_id = organizer.id
    e.name = ed[:name]; e.event_type = ed[:type]
    e.tagline = ed[:tagline]; e.description = ed[:description]
    e.location = ed[:location]; e.start_date = ed[:start]; e.end_date = ed[:end]
    e.status = ed[:status]; e.hero_image = ed[:hero]; e.capacity = ed[:capacity]
  end

  created_speakers = ed[:speakers].map do |sp|
    Speaker.find_or_create_by!(event_id: ev.id, name: sp[:name]) do |s|
      s.id = uid; s.title = sp[:title]; s.company = sp[:company]
    end
  end

  ed[:sessions].each do |sess|
    sp_id = sess[:speaker_idx] ? created_speakers[sess[:speaker_idx]]&.id : nil
    EventSession.find_or_create_by!(event_id: ev.id, title: sess[:title]) do |s|
      s.id = uid; s.speaker_id = sp_id; s.track = sess[:track]
      s.kind = sess[:kind]; s.starts_at = sess[:starts]; s.ends_at = sess[:ends]; s.room = sess[:room]
    end
  end

  ed[:tiers].each_with_index do |t, i|
    TicketTier.find_or_create_by!(event_id: ev.id, name: t[:name]) do |tier|
      tier.id = uid; tier.price_cents = t[:price]; tier.quantity = t[:qty]; tier.sort_order = i
    end
  end

  ev
end

# ── Registrations ─────────────────────────────────────────────────────────────
e1 = created_events[0]
e2 = created_events[1]

# Main attendee registers for FutureStack + Northstar
unless Registration.exists?(event: e1, user: attendee)
  t = e1.ticket_tiers.find_by(name: "Regular")
  Registration.create!(id: uid, event: e1, user: attendee, ticket_tier: t, code: tcode)
end

unless Registration.exists?(event: e2, user: attendee)
  t = e2.ticket_tiers.find_by(name: "Regular")
  Registration.create!(id: uid, event: e2, user: attendee, ticket_tier: t, code: tcode)
end

# Extra attendees for FutureStack (some checked in) — to hit 1,162/3,000 approx
extras.each_with_index do |u, i|
  next if Registration.exists?(event: e1, user: u)
  tier_name = i.even? ? "VIP" : "Early Bird"
  t = e1.ticket_tiers.find_by(name: tier_name) || e1.ticket_tiers.first
  reg = Registration.create!(id: uid, event: e1, user: u, ticket_tier: t, code: tcode)
  reg.update!(checked_in_at: Time.now - (i * 3600)) if i < 3
end

puts "✓ Seed complete. Login: organizer@demo.letskonnect.app / attendee@demo.letskonnect.app / admin@demo.letskonnect.app (password: demo1234)"
