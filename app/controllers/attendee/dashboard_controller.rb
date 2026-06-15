class Attendee::DashboardController < Attendee::BaseController
  def index
    @registrations = current_user.registrations.includes(:event, :ticket_tier).order("events.start_date")
  end
end
