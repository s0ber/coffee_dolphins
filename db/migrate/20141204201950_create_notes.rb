class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :title
      t.text :comment
      t.references :notable, polymorphic: true, index: true
      t.belongs_to :user
      t.timestamps
    end
  end
end
