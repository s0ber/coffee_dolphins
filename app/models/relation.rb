class Relation < ActiveRecord::Base
  KINDS = {one: 0, many: 1}
  KINDS_INVERTED = KINDS.invert

  belongs_to :resource
  belongs_to :related_resource, class_name: 'Resource'
  acts_as_list scope: :resource, top_of_list: 0

  validates :kind, :related_resource_id, :resource_id, presence: true

  def kind_humanized
    kind_readable.to_s.humanize
  end

  def kind_readable
    KINDS_INVERTED[self.kind]
  end
end
