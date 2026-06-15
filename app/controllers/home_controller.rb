class HomeController < ApplicationController
  def index
    if signed_in?
      case current_user.role
      when "organizer" then redirect_to organizer_root_path
      when "admin"     then redirect_to admin_root_path
      else                  redirect_to attendee_root_path
      end
    end
    @published_events = Event.published.order(:start_date).limit(6)
  end
end
