class Organizer::EventsController < Organizer::BaseController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :publish, :unpublish, :archive, :attendees, :analytics]

  def index
    @events = current_user.organized_events.order(created_at: :desc)
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params.merge(organizer_id: current_user.id))
    if @event.save
      @event.ticket_tiers.create!(
        id: SecureRandom.alphanumeric(12), name: "General Admission", price_cents: 0, quantity: 100
      )
      redirect_to organizer_event_path(@event), notice: "Event created! Add ticket types and start building your agenda."
    else
      flash.now[:alert] = @event.errors.full_messages.first
      render :new, status: :unprocessable_content
    end
  end

  def show
    @tiers    = @event.ticket_tiers.order(:sort_order)
    @sessions = @event.event_sessions.order(:starts_at)
    @speakers = @event.speakers
  end

  def edit; end

  def update
    if @event.update(event_params)
      redirect_to organizer_event_path(@event), notice: "Event updated."
    else
      flash.now[:alert] = @event.errors.full_messages.first
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @event.destroy
    redirect_to organizer_events_path, notice: "Event deleted."
  end

  def publish
    @event.update!(status: "published")
    redirect_back fallback_location: organizer_event_path(@event), notice: "Event is now live."
  end

  def unpublish
    @event.update!(status: "draft")
    redirect_back fallback_location: organizer_event_path(@event), notice: "Event set to draft."
  end

  def archive
    @event.update!(status: "archived")
    redirect_back fallback_location: organizer_event_path(@event), notice: "Event archived."
  end

  def attendees
    @registrations = @event.registrations.includes(:user, :ticket_tier).order(created_at: :desc)
  end

  def analytics
    @tiers = @event.ticket_tiers.order(:sort_order)
  end

  private

  def set_event
    @event = if current_user.admin?
               Event.find_by!(id: params[:id])
             else
               current_user.organized_events.find_by!(id: params[:id])
             end
    redirect_to organizer_events_path, alert: "Event not found." unless @event
  end

  def event_params
    params.require(:event).permit(
      :name, :event_type, :tagline, :description,
      :location, :start_date, :end_date, :hero_image, :capacity, :status
    )
  end
end
