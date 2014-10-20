class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates :email, presence: true, uniqueness: true, email: true
  validates :password, presence: true, confirmation: true, length: {within: 6...128}
  validates :password_confirmation, presence: true
end
