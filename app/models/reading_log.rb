class ReadingLog < ApplicationRecord
  belongs_to :user
  belongs_to :book

  enum :status, {
    unread:   0,
    progress: 1,
    read:     2
  }, validate: true
end
