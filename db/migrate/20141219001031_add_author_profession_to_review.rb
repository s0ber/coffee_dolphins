class AddAuthorProfessionToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :author_profession, :string
  end
end
