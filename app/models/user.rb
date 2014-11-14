class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates :email, presence: true, uniqueness: true, email: true
  validates :password, confirmation: true, length: {within: 6...128}, allow_blank: true
  validates :full_name, presence: true, length: {maximum: 255}
  before_validation :check_password, on: :create

  default_scope { order(:created_at) }

  attr_accessor :remember_me

  def admin?
    email == 'coffeedolphins@gmail.com'
  end

private

  def check_password
    if self.password.blank?
      self.errors.add :password, :blank
    end
  end
end
