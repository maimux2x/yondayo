class Book < ApplicationRecord
  has_one_attached :cover do |attachable|
    attachable.variant :ogp, resize_to_pad: [1200, 630, {background: 'white'}]
  end

  has_many :readings, dependent: :destroy

  validates :title, presence: true
end
