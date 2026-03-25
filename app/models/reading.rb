class Reading < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :user_id, uniqueness: {scope: :book_id}

  enum :status, {
    unread:   0,
    progress: 1,
    read:     2
  }, validate: true
end
