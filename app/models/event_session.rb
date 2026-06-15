class EventSession < ApplicationRecord
  belongs_to :event
  belongs_to :speaker, optional: true
  validates :title, :starts_at, :ends_at, presence: true
  before_create :set_id

  KINDS = %w[Keynote Talk Workshop Panel Networking].freeze

  def time_range
    s = starts_at.to_s; e = ends_at.to_s
    "#{s[11, 5]} – #{e[11, 5]}"
  rescue
    "#{starts_at} – #{ends_at}"
  end

  private
  def set_id; self.id ||= SecureRandom.alphanumeric(12); end
end
