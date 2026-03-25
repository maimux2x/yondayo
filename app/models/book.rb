class Book < ApplicationRecord
  has_many :readings, dependent: :destroy

  validates :title,  presence: true
  validates :author, presence: true
end
