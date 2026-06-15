class Admin::DashboardController < Admin::BaseController
  def index
    @tenants       = Tenant.order(created_at: :desc).limit(10)
    @support_tickets = SupportTicket.where(status: ["open", "in_progress"])
                                    .where(priority: ["high", "urgent"])
                                    .order(created_at: :desc).limit(10)
    @active_tenants = Tenant.where(status: "active").count
    @total_tenants  = Tenant.count
    @mrr_cents      = Tenant.where(status: "active").sum(:monthly_cents)
    @active_subs    = Tenant.where(status: "active").count
    @past_due       = Tenant.where(status: "active", monthly_cents: 0).count
    @events_hosted  = Event.count
    @live_this_week = Event.where(status: "published")
                          .where("start_date <= ? AND end_date >= ?", 7.days.from_now.to_date.to_s, Date.today.to_s).count
    @open_tickets   = SupportTicket.where(status: "open").count
    @urgent_tickets = SupportTicket.where(priority: "urgent", status: "open").count
  end
end
