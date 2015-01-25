class AddReviewsFooterToLandings < ActiveRecord::Migration
  def change
    add_column :landings, :reviews_footer, :string
  end
end
