class Admin::TransactionsController < Admin::BaseController
  before_action :load_transaction, only: [:edit, :update, :confirm_destroy, :destroy]

  def new
    @bookmaker = Bookmaker.find(params[:bookmaker_id])
    @transaction = @bookmaker.transactions.build
    render_modal("Добавление денег для <b>#{@bookmaker.title}</b>")
  end

  def create
    transaction = Transaction.new(transaction_params)
    transaction.bookmaker_id = params[:transaction][:bookmaker_id]
    transaction.save!
    render_success(notice: 'Новая транзакция добавлена')
  end

  def edit
    render_modal("Редактирование транзакции для <b>#{@transaction.bookmaker.title}</b>")
  end

  def update
    if @transaction.kind_human == :load
      @transaction.update_attributes!(transaction_params)
      render_success
    end
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
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params
      .fetch(:transaction, {})
      .permit(:ammount_rub, :ammount, :currency, :performed_at)
  end
end
