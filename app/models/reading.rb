class Reading < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :user_id, uniqueness: {scope: :book_id}

  enum :status, {
    unread:      0,
    in_progress: 1,
    read:        2
  }, validate: true

  before_create :generate_share_token

  private

  def generate_share_token
    self.share_token = SecureRandom.urlsafe_base64(16)
  end
end
