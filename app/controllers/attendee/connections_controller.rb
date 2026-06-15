class Attendee::ConnectionsController < Attendee::BaseController
  def create
    event   = Event.find_by(id: params[:event_id])
    to_user = User.find_by(id: params[:to_user_id])
    return redirect_back(fallback_location: attendee_networking_path, alert: "Event not found.") unless event
    return redirect_back(fallback_location: attendee_networking_path, alert: "User not found.") unless to_user

    conn = Connection.new(
      id: SecureRandom.alphanumeric(12), event: event,
      from_user: current_user, to_user: to_user, status: "pending"
    )
    if conn.save
      redirect_back fallback_location: attendee_networking_path, notice: "Connection request sent to #{to_user.name}."
    else
      redirect_back fallback_location: attendee_networking_path, alert: conn.errors.full_messages.first
    end
  end

  def update
    conn = Connection.find_by(id: params[:id], to_user: current_user)
    return redirect_back(fallback_location: attendee_networking_path, alert: "Request not found.") unless conn
    conn.update!(status: params[:status] == "accepted" ? "accepted" : "declined")
    redirect_back fallback_location: attendee_networking_path,
                  notice: params[:status] == "accepted" ? "Connection accepted!" : "Request declined."
  end
end
