class AddWhyQuestionToLandings < ActiveRecord::Migration
  def change
    add_column :landings, :why_question, :string
  end
end
