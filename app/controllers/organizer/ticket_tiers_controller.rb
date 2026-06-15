class Organizer::TicketTiersController < Organizer::BaseController
  def create
    @event = current_user.organized_events.find_by!(id: params[:event_id])
    sort_order = @event.ticket_tiers.maximum(:sort_order).to_i + 1
    tier = @event.ticket_tiers.create!(
      id: SecureRandom.alphanumeric(12),
      name: params[:name],
      price_cents: (params[:price].to_f * 100).to_i,
      quantity: params[:quantity].to_i,
      sort_order: sort_order
    )
    redirect_to organizer_event_path(@event, anchor: "tickets"), notice: "Ticket tier added."
  rescue => e
    redirect_to organizer_event_path(@event, anchor: "tickets"), alert: e.message
  end

  def destroy
    @event = current_user.organized_events.find_by!(id: params[:event_id])
    tier = @event.ticket_tiers.find_by!(id: params[:id])
    if tier.registrations.any?
      redirect_to organizer_event_path(@event, anchor: "tickets"), alert: "Can't delete a tier with registrations."
    else
      tier.destroy
      redirect_to organizer_event_path(@event, anchor: "tickets"), notice: "Tier deleted."
    end
  end
end
