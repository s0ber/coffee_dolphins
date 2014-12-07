class NoteDecorator < ApplicationDecorator
  def comment
    h.auto_link(
      h.simple_format(h.html_escape(object.comment)),
      html: {target: '_blank'}
    )
  end

  def edit_button
    h.link_to h.fa_icon('pencil'),
      h.edit_note_path(object),
      class: 'note-button',
      remote: true,
      data: {role: 'editable_item-edit_button'}
  end

  def remove_button
    h.link_to h.fa_icon('close'),
      h.note_path(object),
      class: 'note-button',
      remote: true,
      method: :delete,
      data: {role: 'item-remove_button', confirm: "Удалить заметку #{object.title}?"}
  end
end
