class Polymorphic::NotesController < ApplicationController
  before_filter :load_note, only: [:show, :edit, :update, :destroy]

  def create
    note = Note.new(note_params)
    note.notable = notable
    note.user = current_user
    note.save!
    render_partial('note', note: note)
  end

  def show
    render_partial('note', note: @note)
  end

  def edit
    respond_with(@note)
  end

  def update
    @note.update_attributes!(note_params)
    render_success
  end

  def destroy
    @note.destroy
    render_success
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
