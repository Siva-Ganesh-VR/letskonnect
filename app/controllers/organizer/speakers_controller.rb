class Organizer::SpeakersController < Organizer::BaseController
  def create
    @event = current_user.organized_events.find_by!(id: params[:event_id])
    @event.speakers.create!(
      id: SecureRandom.alphanumeric(12),
      name: params[:name], title: params[:title] || "", company: params[:company] || ""
    )
    redirect_to organizer_event_path(@event, anchor: "agenda"), notice: "Speaker added."
  rescue => e
    redirect_to organizer_event_path(@event, anchor: "agenda"), alert: e.message
  end

  def destroy
    @event = current_user.organized_events.find_by!(id: params[:event_id])
    @event.speakers.find_by!(id: params[:id]).destroy
    redirect_to organizer_event_path(@event, anchor: "agenda"), notice: "Speaker removed."
  end
end
