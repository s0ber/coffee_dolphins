class AddBetIdToTransactions < ActiveRecord::Migration
  def change
    add_reference :transactions, :bet, index: true
  end
end
