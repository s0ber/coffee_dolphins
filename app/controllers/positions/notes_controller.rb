class Positions::NotesController < Polymorphic::NotesController

protected

  def notable
    @notable ||= Position.find(params[:position_id])
  end
end
