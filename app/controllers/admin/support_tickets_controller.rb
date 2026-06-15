class Admin::SupportTicketsController < Admin::BaseController
  def index
    scope = SupportTicket.includes(:tenant).order(created_at: :desc)
    scope = scope.where(status: params[:status])   if params[:status].present?
    scope = scope.where(priority: params[:priority]) if params[:priority].present?
    @pagy, @tickets = pagy(scope, items: 20)
  end

  def show
    @ticket = SupportTicket.find_by!(id: params[:id])
  end

  def update
    @ticket = SupportTicket.find_by!(id: params[:id])
    @ticket.update!(status: params[:status]) if params[:status].present?
    redirect_back fallback_location: admin_support_tickets_path
  end
end
