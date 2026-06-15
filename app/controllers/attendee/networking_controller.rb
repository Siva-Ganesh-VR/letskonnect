class Attendee::NetworkingController < Attendee::BaseController
  def index
    @registered_events = current_user.registered_events.where(status: "published")
    @event = @registered_events.find_by(id: params[:event_id]) || @registered_events.first

    if @event
      @people = @event.attendees.where.not(id: current_user.id).includes(:registrations)
      @connections = Connection.where(event: @event)
                               .where("from_user_id = ? OR to_user_id = ?", current_user.id, current_user.id)
      @incoming = @connections.where(to_user_id: current_user.id, status: "pending")

      mine = (current_user.interests || "").downcase.split(/[,;]+/).map(&:strip).reject(&:empty?)
      @scored = @people.map do |p|
        theirs  = (p.interests || "").downcase.split(/[,;]+/).map(&:strip).reject(&:empty?)
        overlap = theirs.count { |t| mine.any? { |m| m.present? && (t.include?(m) || m.include?(t)) } }
        { user: p, match: overlap }
      end.sort_by { |x| -x[:match] }
    end
  end
end
