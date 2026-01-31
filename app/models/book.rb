class Book < ApplicationRecord
  has_many :reading_logs, dependent: :destroy

  validates :title,  presence: true
  validates :author, presence: true
end
