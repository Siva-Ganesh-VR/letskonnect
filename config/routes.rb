Rails.application.routes.draw do
  root "sessions#new"

  # Auth
  get    "login",      to: "sessions#new",        as: :login
  post   "login",      to: "sessions#create"
  delete "logout",     to: "sessions#destroy",    as: :logout
  get    "signup",     to: "registrations#new",   as: :signup
  post   "signup",     to: "registrations#create"
  post   "demo_login", to: "sessions#demo",        as: :demo_login
  post   "switch_role",to: "sessions#switch_role", as: :switch_role

  # Public event microsite
  get  "events",          to: "events#index",    as: :public_events
  get  "events/:slug",    to: "events#show",     as: :public_event
  post "events/:slug/register", to: "events#register", as: :event_register

  # ── Organizer portal ──────────────────────────────────────────────────────
  namespace :organizer do
    get "/",        to: "dashboard#index", as: :root
    get "dashboard",to: "dashboard#index"

    resources :events do
      member do
        patch :publish
        patch :unpublish
        patch :archive
        get   :attendees
        get   :analytics
      end
      # Check-in console (index = show form, create = scan POST)
      resources :checkin, only: [:index] do
        collection { post :scan }
      end
      resources :ticket_tiers,   only: [:create, :destroy]
      resources :sessions,        only: [:create, :destroy],
                                  controller: "event_sessions", as: :sessions
      resources :speakers,        only: [:create, :destroy]
    end

    resources :registrations, only: [:index]
  end

  # ── Attendee portal ───────────────────────────────────────────────────────
  namespace :attendee do
    get "/",          to: "dashboard#index", as: :root
    get "dashboard",  to: "dashboard#index"
    get "discover",   to: "discover#index"
    get "networking", to: "networking#index"
    resources :connections, only: [:create, :update]
  end

  # ── Super Admin portal ────────────────────────────────────────────────────
  namespace :admin do
    get "/",        to: "dashboard#index", as: :root
    get "dashboard",to: "dashboard#index"
    resources :tenants,         only: [:index, :show, :edit, :update]
    resources :subscriptions,   only: [:index]
    resources :support_tickets, only: [:index, :show, :update]
    resources :users,           only: [:index, :show, :edit, :update, :destroy]
    resources :events,          only: [:index, :show]
  end
end
