class BookLog < ApplicationRecord
  has_many :books, dependent: :destroy

  enum :status, {
    unread:   0,
    progress: 1,
    read:     2
  }, validate: true
end
