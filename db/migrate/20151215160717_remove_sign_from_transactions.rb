class RemoveSignFromTransactions < ActiveRecord::Migration
  def change
    remove_column :transactions, :sign, :integer
  end
end
