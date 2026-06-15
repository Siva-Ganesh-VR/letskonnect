class Organizer::EventSessionsController < Organizer::BaseController
  def create
    @event = current_user.organized_events.find_by!(id: params[:event_id])
    @event.event_sessions.create!(
      id: SecureRandom.alphanumeric(12),
      title: params[:title], track: params[:track] || "Main stage",
      kind: params[:kind] || "Talk", starts_at: params[:starts_at],
      ends_at: params[:ends_at], speaker_id: params[:speaker_id].presence,
      room: params[:room] || ""
    )
    redirect_to organizer_event_path(@event, anchor: "agenda"), notice: "Session added."
  rescue => e
    redirect_to organizer_event_path(@event, anchor: "agenda"), alert: e.message
  end

  def destroy
    @event = current_user.organized_events.find_by!(id: params[:event_id])
    @event.event_sessions.find_by!(id: params[:id]).destroy
    redirect_to organizer_event_path(@event, anchor: "agenda"), notice: "Session removed."
  end
end
