class User < ApplicationRecord
  has_secure_password
  has_many :organized_events, class_name: "Event", foreign_key: :organizer_id, dependent: :destroy
  has_many :registrations, dependent: :destroy
  has_many :registered_events, through: :registrations, source: :event
  has_many :sent_connections,     class_name: "Connection", foreign_key: :from_user_id, dependent: :destroy
  has_many :received_connections, class_name: "Connection", foreign_key: :to_user_id,   dependent: :destroy

  validates :name,  presence: true
  validates :email, presence: true, uniqueness: { case_insensitive: true }
  validates :role,  inclusion: { in: %w[organizer attendee admin] }

  before_save { email.downcase! }
  before_create :set_id

  ROLES = %w[organizer attendee admin].freeze

  def organizer? = role == "organizer"
  def attendee?  = role == "attendee"
  def admin?     = role == "admin"

  def initials
    name.split(" ").first(2).map { |w| w[0] }.join.upcase
  end

  private
  def set_id
    self.id ||= SecureRandom.alphanumeric(12)
  end
end
