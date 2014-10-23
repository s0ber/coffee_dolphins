class User < ActiveRecord::Base
  authenticates_with_sorcery!

  scope :active, -> { order(:created_at) }

  attr_accessor :remember_me

  validates :email, presence: true, uniqueness: true, email: true
  validates :password, presence: true, confirmation: true, length: {within: 6...128}
  validates :password_confirmation, presence: true
end
