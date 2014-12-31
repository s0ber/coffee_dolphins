class AddDefaultValueForLandingsColor < ActiveRecord::Migration
  def change
    change_column :landings, :color, :integer, limit: 2, default: 0

    Landing.all.each do |landing|
      landing.color = 0 if landing.color.nil?
      landing.save
    end
  end
end
