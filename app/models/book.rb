class Book < ApplicationRecord
  has_one_attached :cover

  has_many :readings, dependent: :destroy

  normalizes :isbn, with: -> { it.delete('-') }

  validates :title,  presence: true
  validates :author, presence: true
end
