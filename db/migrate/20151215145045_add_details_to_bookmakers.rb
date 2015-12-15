class AddDetailsToBookmakers < ActiveRecord::Migration
  def change
    add_column :bookmakers, :statistics_url, :string
  end
end
