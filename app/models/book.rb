class Book < ApplicationRecord
  belongs_to :user

  validates :title,  presence: true
  validates :author, presence: true

  enum :status, {
    unread:   0,
    progress: 1,
    read:     2
  }, validate: true
end
