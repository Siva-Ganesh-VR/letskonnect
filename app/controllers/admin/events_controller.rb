class Admin::EventsController < Admin::BaseController
  def index
    @pagy, @events = pagy(Event.includes(:organizer).order(created_at: :desc), items: 25)
  end

  def show
    @event = Event.find_by!(id: params[:id])
    @registrations = @event.registrations.includes(:user, :ticket_tier)
  end
end
