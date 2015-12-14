class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|
      t.belongs_to :fork, index: true
      t.belongs_to :bookmaker, index: true
      t.decimal :ammount
      t.decimal :prize
      t.integer :result

      t.timestamps
    end
  end
end
