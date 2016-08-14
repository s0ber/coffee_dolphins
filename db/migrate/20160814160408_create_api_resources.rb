class CreateApiResources < ActiveRecord::Migration
  def change
    create_table :api_resources do |t|
      t.string :guid
      t.string :parent_guid
      t.belongs_to :resource, index: true
      t.string :kind
      t.belongs_to :endpoint, index: true

      t.timestamps
    end
  end
end
