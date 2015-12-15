class Admin::BetsController < Admin::BaseController
  before_action :load_bet, only: [:edit, :update, :show, :confirm_destroy, :destroy]

  def new
    @fork = Fork.find(params[:fork_id])
    @bet = @fork.bets.build
    render_modal("Добавление ставки для вилки <b>#{@fork.title}</b>")
  end

  def create
    bet = Bet.new(bet_params)
    bet.fork_id = params[:bet][:fork_id]
    bet.save!
    render_success(notice: 'Ставка добавлена')
  end

  def edit
    render_modal("Редактирование ставки для вилки <b>#{@bet.fork.title}</b>")
  end

  def update
    @bet.update_attributes!(bet_params)
    render_success(notice: 'Ставка обновлена')
  end

  def confirm_destroy
    render_modal('Удалить ставку?')
  end

  def destroy
    @bet.destroy
    render_success
  end

  private

  def load_bet
    @bet = Bet.find(params[:id])
  end

  def bet_params
    params.fetch(:bet, {}).permit(:ammount_rub, :prize, :bookmaker_id, :outcome)
  end
end
