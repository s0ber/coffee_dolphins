class AddReviewsTitleToLanding < ActiveRecord::Migration
  def change
    add_column :landings, :reviews_title, :string
  end
end
