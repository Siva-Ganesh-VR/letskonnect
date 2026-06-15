class Organizer::CheckinController < Organizer::BaseController
  before_action :set_event

  def index
    @total      = @event.registration_count
    @checked_in = @event.checked_in_count
  end

  def scan
    code = params[:code].to_s.strip.upcase
    reg  = Registration.includes(:user, :ticket_tier)
                       .find_by(code: code, event: @event)

    if reg.nil?
      render json: { ok: false, error: "No badge found for code #{code} at this event." }
    elsif reg.checked_in?
      render json: {
        ok: false,
        error: "Already checked in at #{reg.checked_in_at.strftime('%H:%M %b %-d')}.",
        code: code
      }
    else
      reg.update!(checked_in_at: Time.now)
      render json: {
        ok: true,
        name: reg.user.name,
        tier: reg.ticket_tier.name,
        code: code,
        time: Time.now.strftime("%H:%M:%S")
      }
    end
  end

  private

  def set_event
    @event = if current_user.admin?
               Event.find_by!(id: params[:event_id])
             else
               current_user.organized_events.find_by!(id: params[:event_id])
             end
  end
end
