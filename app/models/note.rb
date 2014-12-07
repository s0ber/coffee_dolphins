class Note < ActiveRecord::Base
  belongs_to :notable, polymorphic: true
  belongs_to :user

  validates :title, :comment, :user_id, :notable_id, :notable_type, presence: true
  validates :title, length: {maximum: 255}

  default_scope { order(id: :asc) }
end
