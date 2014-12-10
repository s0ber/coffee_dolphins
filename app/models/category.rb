class Category < ActiveRecord::Base
  validates :title, :slug, :description, :html_title, :meta_keywords, :meta_description, presence: true
  validates :slug, uniqueness: true

  has_many :landings, dependent: :delete_all

  default_scope { order(:title) }
end
