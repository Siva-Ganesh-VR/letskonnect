class SupportTicket < ApplicationRecord
  belongs_to :tenant, optional: true
  validates :subject, presence: true
  validates :priority, inclusion: { in: %w[normal high urgent] }
  validates :status,   inclusion: { in: %w[open in_progress resolved] }
  before_create :set_id
  private
  def set_id; self.id ||= SecureRandom.alphanumeric(12); end
end
