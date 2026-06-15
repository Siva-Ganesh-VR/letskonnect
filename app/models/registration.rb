class Registration < ApplicationRecord
  belongs_to :event
  belongs_to :user
  belongs_to :ticket_tier

  validates :code, presence: true, uniqueness: true
  validates :event_id, uniqueness: { scope: :user_id, message: "You are already registered for this event." }

  before_create :set_id

  def checked_in? = checked_in_at.present?

  private
  def set_id; self.id ||= SecureRandom.alphanumeric(12); end
end
