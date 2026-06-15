class Tenant < ApplicationRecord
  has_many :support_tickets, dependent: :nullify
  before_create :set_id
  PLANS = %w[starter growth enterprise].freeze

  def monthly_display
    monthly_cents == 0 ? "$0/mo" : "$#{monthly_cents / 100}/mo"
  end

  private
  def set_id; self.id ||= SecureRandom.alphanumeric(12); end
end
