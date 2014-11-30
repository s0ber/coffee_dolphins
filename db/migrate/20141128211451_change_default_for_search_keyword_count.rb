class ChangeDefaultForSearchKeywordCount < ActiveRecord::Migration
  def change
    change_column :search_keywords, :search_count, :integer, default: 0
  end
end
