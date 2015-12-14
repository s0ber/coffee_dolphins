class CreateMoneyLoadTransactions < ActiveRecord::Migration
  def change
    create_table :money_load_transactions do |t|
      t.decimal :ammount_rub
      t.decimal :ammount
      t.integer :currency
      t.belongs_to :bookmaker, index: true
      t.datetime :performed_at

      t.timestamps
    end
  end
end
