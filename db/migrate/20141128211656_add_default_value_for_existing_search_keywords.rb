class AddDefaultValueForExistingSearchKeywords < ActiveRecord::Migration
  def up
    SearchKeyword.update_all(search_count: 0)
  end

  def down
  end
end
