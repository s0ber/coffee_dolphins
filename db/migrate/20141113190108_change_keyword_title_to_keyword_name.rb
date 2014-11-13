class ChangeKeywordTitleToKeywordName < ActiveRecord::Migration
  def change
    rename_column :search_keywords, :title, :name
  end
end
