class Connection < ApplicationRecord
  belongs_to :event
  belongs_to :from_user, class_name: "User", foreign_key: :from_user_id
  belongs_to :to_user,   class_name: "User", foreign_key: :to_user_id

  validates :status, inclusion: { in: %w[pending accepted declined] }
  validates :from_user_id, uniqueness: { scope: [:event_id, :to_user_id] }

  before_create :set_id

  private
  def set_id; self.id ||= SecureRandom.alphanumeric(12); end
end
