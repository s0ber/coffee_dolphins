class Admin::MoneyLoadTransactionsController < Admin::BaseController
  def new
    @bookmaker = Bookmaker.find(params[:bookmaker_id])
    @money_load_transaction = @bookmaker.money_load_transactions.build
    render_modal('Добавление денег для БК')
  end

  def create
    MoneyLoadTransaction.create!(money_load_transaction_params)
    render_success(notice: 'Новая транзакция добавлена')
  end

  protected

  def money_load_transaction_params
    params
      .fetch(:money_load_transaction, {})
      .permit(:ammount, :currency, :performed_at, :exchange_rate, :bookmaker_id)
  end
end
