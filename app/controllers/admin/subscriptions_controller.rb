class Admin::SubscriptionsController < Admin::BaseController
  def index
    @tenants = Tenant.order(:plan, :name)
  end
end
