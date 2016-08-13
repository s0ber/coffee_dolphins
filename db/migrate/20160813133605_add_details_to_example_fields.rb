class AddDetailsToExampleFields < ActiveRecord::Migration
  def change
    add_column :example_fields, :value, :string
  end
end
