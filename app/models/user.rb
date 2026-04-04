class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_one_attached :avatar do |attachable|
    attachable.variant :profile, resize_to_limit: [100, 100]
    attachable.variant :icon,    resize_to_limit: [50, 50]
  end

  has_many :readings, dependent: :destroy
  has_many :books,    through: :readings

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name,          presence: true
  validates :email_address, presence: true
end
