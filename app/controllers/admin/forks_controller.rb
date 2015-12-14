class Admin::ForksController < Admin::BaseController
  before_filter :load_fork, only: [:show, :edit, :update, :destroy]

  def create
    @fork = Fork.new(fork_params)
    @fork.bet_line_id = params[:fork][:bet_line_id]
    @fork.save!
    render_partial('fork', fork: @fork.decorate)
  end

  def show
    render_partial('fork', fork: @fork.decorate)
  end

  def edit
    respond_with(@fork)
  end

  def update
    @fork.update_attributes!(fork_params)
    render_success
  end

  def destroy
    @fork.destroy
    render_success
  end

  protected

  def load_fork
    @fork = Fork.find(params[:id])
  end

  def fork_params
    params.fetch(:fork, {}).permit(bets_attributes: [:id, :ammount_rub, :prize, :bookmaker_id])
  end
end
