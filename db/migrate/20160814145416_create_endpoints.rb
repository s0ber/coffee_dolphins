class CreateEndpoints < ActiveRecord::Migration
  def change
    create_table :endpoints do |t|
      t.integer :request_method, limit: 1
      t.string :path
      t.belongs_to :api_group, index: true

      t.timestamps
    end
  end
end
