class Book < ApplicationRecord
  belongs_to :book_log

  validates :title,  presence: true
  validates :author, presence: true
end
