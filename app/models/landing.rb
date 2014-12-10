class Landing < ActiveRecord::Base
  include StatusHolder

  before_validation :set_as_draft, on: :create

  validates :title, :slug, :category_id, :position_id, :_status, presence: true
  validates :slug, uniqueness: true
  validates :price,
            :old_price,
            :apishops_price,
            :max_click_cost,
            :video_url,
            :color,
            :apishops_article_id,
            :meta_description,
            :html_title,
            :meta_description,
              presence: true, on: :update, if: :published?

  belongs_to :category
  belongs_to :position

  default_scope { order(:created_at) }


  def set_as_draft
    self._status = :draft
  end

  def set_as_published
    self._status = :published
  end

  def published?
    self._status == :published
  end
end
