class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_one_attached :avatar

  has_many :readings, dependent: :destroy
  has_many :books,    through: :readings

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name,          presence: true
  validates :email_address, presence: true
end
