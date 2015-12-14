class AddDetailsToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :sign, :integer, default: 0
    add_column :transactions, :kind, :integer, default: 0
  end
end
