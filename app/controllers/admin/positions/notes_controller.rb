class Admin::Positions::NotesController < Admin::Polymorphic::NotesController

protected

  def notable
    @notable ||= Position.find(params[:position_id])
  end
end
