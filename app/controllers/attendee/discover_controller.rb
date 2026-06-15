class Attendee::DiscoverController < Attendee::BaseController
  def index
    @events = Event.published.order(:start_date)
  end
end
