class CreateApiGroups < ActiveRecord::Migration
  def change
    create_table :api_groups do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
