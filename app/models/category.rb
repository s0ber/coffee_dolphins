class Category < ActiveRecord::Base
  validates :title, :slug, :description, :html_title, :meta_keywords, :meta_description, presence: true

  has_many :landings

  default_scope { order(:title) }
end
