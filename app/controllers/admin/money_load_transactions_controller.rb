class Admin::MoneyLoadTransactionsController < Admin::BaseController
  before_action :load_transaction, only: [:edit, :update, :confirm_destroy, :destroy]
  def new
    @bookmaker = Bookmaker.find(params[:bookmaker_id])
    @transaction = @bookmaker.money_load_transactions.build
    render_modal('Добавление денег для БК')
  end

  def create
    transaction = MoneyLoadTransaction.new(money_load_transaction_params)
    transaction.bookmaker_id = params[:money_load_transaction][:bookmaker_id]
    transaction.save!
    render_success(notice: 'Новая транзакция добавлена')
  end

  def edit
    render_modal('Редактирование транзакции')
  end

  def update
    @transaction.update_attributes!(money_load_transaction_params)
    render_success
  end

  def confirm_destroy
    render_modal('Удалить транзакцию?')
  end

  def destroy
    @transaction.destroy
    render_success
  end

  protected

  def load_transaction
    @transaction = MoneyLoadTransaction.find(params[:id])
  end

  def money_load_transaction_params
    params
      .fetch(:money_load_transaction, {})
      .permit(:ammount_rub, :ammount, :currency, :performed_at)
  end
end
