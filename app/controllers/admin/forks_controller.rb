class Admin::ForksController < Admin::BaseController
  before_filter :load_fork, only: [:show, :edit, :update, :destroy, :select_winner, :set_winner]

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

  def select_winner
    @fork = @fork.decorate
    render_modal("Выберите победителя вилки <b>#{@fork.title}</b>")
  end

  def set_winner
    @fork.update_attributes!(played_out_at: Time.zone.now,
                             winning_bet_id: params[:fork][:winning_bet_id])
    render_success
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
    params.fetch(:fork, {}).permit(:title, bets_attributes: [:id, :ammount_rub, :prize, :bookmaker_id])
  end
end
