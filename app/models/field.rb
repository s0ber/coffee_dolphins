class Field < ActiveRecord::Base
  belongs_to :type
  belongs_to :resource
  acts_as_list scope: :resource, top_of_list: 0

  has_many :example_field, dependent: :destroy

  validates :name, :type_id, :resource_id, presence: true
  after_create :add_example_field_for_resource_examples

  def add_example_field_for_resource_examples
    self.resource.examples.each do |example|
      example.example_fields << ExampleField.new(field: self)
    end
  end
end
