class Admin::MoneyLoadTransactionsController < Admin::BaseController
  def new
    @bookmaker = Bookmaker.find(params[:bookmaker_id])
    @money_load_transaction = @bookmaker.money_load_transactions.build
    render_modal('Добавление денег для БК')
  end

  def create
    transaction = MoneyLoadTransaction.new(money_load_transaction_params)
    if transaction.currency == 0
      transaction.ammount = transaction.ammount_rub
    end
    transaction.save!
    render_success(notice: 'Новая транзакция добавлена')
  end

  def confirm_destroy
    @transaction = MoneyLoadTransaction.find(params[:id])
    render_modal('Удалить транзакцию?')
  end

  def destroy
    MoneyLoadTransaction.find(params[:id]).destroy
    render_success
  end

  protected

  def money_load_transaction_params
    params
      .fetch(:money_load_transaction, {})
      .permit(:ammount_rub, :ammount, :currency, :performed_at, :bookmaker_id)
  end
end
