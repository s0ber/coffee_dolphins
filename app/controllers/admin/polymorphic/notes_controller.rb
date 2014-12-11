class Admin::Polymorphic::NotesController < Admin::BaseController
  before_filter :load_note, only: [:show, :edit, :update, :destroy]

  def create
    note = Note.new(note_params)
    note.notable = notable
    note.user = current_user
    note.save!
    render_partial('note', note: note.decorate, notice: 'Заметка добавлена')
  end

  def show
    render_partial('note', note: @note.decorate)
  end

  def edit
    respond_with(@note)
  end

  def update
    @note.update_attributes!(note_params)
    render_success(notice: 'Заметка обновлена')
  end

  def destroy
    @note.destroy
    render_success(notice: 'Заметка удалена')
  end

protected

  def load_note
    @note = Note.find(params[:id])
  end

  def notable
    raise NotImplementedError
  end

private

  def note_params
    params.require(:note).permit(:title, :comment)
  end
end
