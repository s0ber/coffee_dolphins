class AddDetailsToForks < ActiveRecord::Migration
  def change
    add_column :forks, :title, :string
  end
end
