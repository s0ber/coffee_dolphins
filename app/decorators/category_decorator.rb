class CategoryDecorator < ApplicationDecorator

protected

  def confirm_remove_message
    "Удалить категорию #{object.title}?"
  end
end
