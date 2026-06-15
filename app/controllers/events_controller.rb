class EventsController < ApplicationController
  def index
    @events = Event.published.order(:start_date)
  end

  def show
    @event = Event.find_by!(slug: params[:slug])
    unless @event.published? || (signed_in? && (current_user.admin? || @event.organizer_id == current_user&.id))
      redirect_to public_events_path, alert: "Event not found."
    end
    @tiers = @event.ticket_tiers.order(:sort_order)
    @sessions = @event.event_sessions.order(:starts_at)
    @speakers = @event.speakers
    @my_registration = signed_in? ? Registration.find_by(event: @event, user: current_user) : nil
  end

  def register
    require_login
    @event = Event.find_by!(slug: params[:slug])
    tier = TicketTier.find_by(id: params[:tier_id], event: @event)
    if !tier
      redirect_to public_event_path(@event.slug), alert: "Please select a ticket type." and return
    end
    if Registration.exists?(event: @event, user: current_user)
      redirect_to public_event_path(@event.slug), alert: "You're already registered." and return
    end
    if tier.sold_out?
      redirect_to public_event_path(@event.slug), alert: "#{tier.name} is sold out." and return
    end
    reg = Registration.new(event: @event, user: current_user, ticket_tier: tier,
                           code: "LK-#{SecureRandom.alphanumeric(4).upcase}-#{SecureRandom.alphanumeric(4).upcase}")
    if reg.save
      redirect_to attendee_root_path, notice: "Registered! Your badge code is #{reg.code}."
    else
      redirect_to public_event_path(@event.slug), alert: reg.errors.full_messages.first
    end
  end
end
