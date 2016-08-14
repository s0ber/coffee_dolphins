class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.belongs_to :type, index: true
      t.string :name
      t.belongs_to :resource, index: true

      t.timestamps
    end
  end
end
