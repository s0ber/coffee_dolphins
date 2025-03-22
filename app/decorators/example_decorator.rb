class ExampleDecorator < ApplicationDecorator

protected

  def edit_path
    h.edit_resource_example_path(model.resource, model)
  end

  def remove_path
    h.resource_example_path(model.resource, model)
  end

  def confirm_remove_message
    "Remove example ##{object.e_id}?"
  end
end
