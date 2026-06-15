class Event < ApplicationRecord
  belongs_to :organizer, class_name: "User", foreign_key: :organizer_id
  has_many :ticket_tiers, dependent: :destroy
  has_many :speakers, dependent: :destroy
  has_many :event_sessions, dependent: :destroy
  has_many :registrations, dependent: :destroy
  has_many :attendees, through: :registrations, source: :user
  has_many :connections, dependent: :destroy

  validates :name, :start_date, :end_date, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :status, inclusion: { in: %w[draft published archived] }

  before_create :set_id
  before_validation :set_slug, on: :create

  scope :published, -> { where(status: "published") }
  scope :upcoming,  -> { where("start_date >= ?", Date.today.to_s).order(:start_date) }

  STATUS_BADGES = {
    "published" => { label: "Published", css: "badge-green" },
    "draft"     => { label: "Draft",     css: "badge-gray" },
    "archived"  => { label: "Archived",  css: "badge-amber" },
  }.freeze

  def published? = status == "published"
  def draft?     = status == "draft"
  def live?
    return false unless published?
    today = Date.today.to_s
    start_date <= today && end_date >= today
  end

  def registration_count = registrations.count
  def checked_in_count   = registrations.where.not(checked_in_at: nil).count
  def revenue_cents      = registrations.joins(:ticket_tier).sum("ticket_tiers.price_cents")
  def sold_out?          = ticket_tiers.sum(:quantity) <= registration_count

  def date_range
    s = Date.parse(start_date)
    e = Date.parse(end_date)
    s == e ? s.strftime("%b %-d, %Y") : "#{s.strftime("%b %-d")} – #{e.strftime("%b %-d, %Y")}"
  end

  private
  def set_id;   self.id   ||= SecureRandom.alphanumeric(12); end
  def set_slug
    base = name.to_s.downcase.strip.gsub(/[^a-z0-9]+/, "-").gsub(/(^-|-$)/, "")
    self.slug = base
    n = 1
    while Event.exists?(slug: self.slug)
      self.slug = "#{base}-#{n += 1}"
    end
  end
end
