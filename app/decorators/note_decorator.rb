class NoteDecorator < ApplicationDecorator
  def comment
    h.simple_format(h.html_escape(object.comment))
  end
end
