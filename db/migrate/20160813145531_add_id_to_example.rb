class AddIdToExample < ActiveRecord::Migration
  def change
    add_column :examples, :e_id, :integer
  end
end
