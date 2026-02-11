class Book < ApplicationRecord
  has_many :reading_logs, dependent: :destroy

  validates :title,  presence: true
  validates :author, presence: true

  validate :published_at_cannot_be_feature

  def published_at_cannot_be_feature
    return unless published_at.present?

    if published_at > Date.today
      errors.add(:published_at, "未来の日付は使えません。")
    end
  end
end
