class Review < ActiveRecord::Base
  validates :author, :landing_id, presence: true

  belongs_to :landing

  default_scope { order(:id) }

  def by_male?
    author_gender == true
  end
end
