class Admin::BetLinesController < Admin::BaseController
  before_filter :load_bet_line, only: [:show, :cut, :edit, :update, :destroy]

  def index
    @bet_lines = BetLine.all.decorate
    @bet_line = BetLine.new
    respond_with(@bet_lines)
  end

  def create
    @bet_line = BetLine.create!(bet_line_params).decorate
    render_partial('bet_line', bet_line: @bet_line)
  end

  def show
    @bet_line = @bet_line.decorate
    respond_with(@bet_line)
  end

  def cut
    @bet_line = @bet_line.decorate
    render_partial('bet_line', bet_line: @bet_line)
  end

  def edit
    respond_with(@bet_line)
  end

  def update
    @bet_line.update_attributes!(bet_line_params)
    render_success
  end

  def destroy
    @bet_line.destroy
    render_success
  end

private
  def load_bet_line
    @bet_line = BetLine.find(params[:id])
  end

  def bet_line_params
    params.require(:bet_line).permit(:performed_at)
  end
end

