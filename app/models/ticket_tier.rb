class TicketTier < ApplicationRecord
  belongs_to :event
  has_many :registrations, dependent: :restrict_with_error

  validates :name, presence: true
  validates :quantity, numericality: { greater_than: 0 }

  before_create :set_id

  def sold_count = registrations.count
  def remaining  = quantity - sold_count
  def sold_out?  = remaining <= 0
  def price_display = price_cents == 0 ? "Free" : "$#{price_cents / 100}"

  private
  def set_id; self.id ||= SecureRandom.alphanumeric(12); end
end
