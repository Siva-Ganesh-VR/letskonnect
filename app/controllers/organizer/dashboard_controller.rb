class Organizer::DashboardController < Organizer::BaseController
  def index
    @events = current_user.organized_events.order(created_at: :desc)
    @total_registrations = Registration.joins(:event).where(events: { organizer_id: current_user.id }).count
    @total_checked_in    = Registration.joins(:event).where(events: { organizer_id: current_user.id }).where.not(checked_in_at: nil).count
    @total_revenue_cents = Registration.joins(:event, :ticket_tier)
                                       .where(events: { organizer_id: current_user.id })
                                       .sum("ticket_tiers.price_cents")
    @live_count     = @events.count(&:live?)
    @upcoming_count = @events.count { |e| e.published? }
  end
end
