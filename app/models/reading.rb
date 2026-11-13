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
  before_save   :sync_finished_on

  private

  def sync_finished_on
    if read?
      self.finished_on ||= Date.current
    else
      self.finished_on = nil
    end
  end

  def generate_share_token
    self.share_token = SecureRandom.urlsafe_base64(16)
  end
end
