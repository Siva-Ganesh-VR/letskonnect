class Speaker < ApplicationRecord
  belongs_to :event
  has_many :event_sessions, foreign_key: :speaker_id, dependent: :nullify
  validates :name, presence: true
  before_create :set_id
  private
  def set_id; self.id ||= SecureRandom.alphanumeric(12); end
end
