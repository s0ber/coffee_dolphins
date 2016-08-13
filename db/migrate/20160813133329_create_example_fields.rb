class CreateExampleFields < ActiveRecord::Migration
  def change
    create_table :example_fields do |t|
      t.belongs_to :example, index: true
      t.belongs_to :field, index: true

      t.timestamps
    end
  end
end
