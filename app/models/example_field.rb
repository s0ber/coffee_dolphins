class ExampleField < ActiveRecord::Base
  belongs_to :example
  belongs_to :field

  default_scope -> { includes(:field).order('fields.position') }
end
