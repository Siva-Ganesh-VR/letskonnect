class Admin::TenantsController < Admin::BaseController
  def index
    @pagy, @tenants = pagy(Tenant.order(created_at: :desc), items: 20)
  end

  def show
    @tenant = Tenant.find_by!(id: params[:id])
    @tickets = @tenant.support_tickets.order(created_at: :desc)
  end

  def edit
    @tenant = Tenant.find_by!(id: params[:id])
  end

  def update
    @tenant = Tenant.find_by!(id: params[:id])
    if @tenant.update(params.require(:tenant).permit(:name, :plan, :status, :monthly_cents, :billing_email))
      redirect_to admin_tenant_path(@tenant), notice: "Tenant updated."
    else
      render :edit
    end
  end
end
