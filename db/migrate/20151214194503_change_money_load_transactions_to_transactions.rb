class ChangeMoneyLoadTransactionsToTransactions < ActiveRecord::Migration
  def change
    rename_table :money_load_transactions, :transactions
  end
end
