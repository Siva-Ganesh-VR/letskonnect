class Organizer::RegistrationsController < Organizer::BaseController
  def index
    regs = Registration.joins(:event).where(events: { organizer_id: current_user.id })
                       .includes(:user, :event, :ticket_tier).order(created_at: :desc)
    @pagy, @registrations = pagy(regs, items: 25)
  end
end
