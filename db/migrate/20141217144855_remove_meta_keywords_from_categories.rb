class RemoveMetaKeywordsFromCategories < ActiveRecord::Migration
  def change
    remove_column :categories, :meta_keywords, :string
  end
end
