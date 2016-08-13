class CreateExamples < ActiveRecord::Migration
  def change
    create_table :examples do |t|
      t.belongs_to :resource, index: true

      t.timestamps
    end
  end
end
