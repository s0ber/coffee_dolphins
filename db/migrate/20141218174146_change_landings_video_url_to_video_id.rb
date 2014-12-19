class ChangeLandingsVideoUrlToVideoId < ActiveRecord::Migration
  def change
    rename_column :landings, :video_url, :video_id
  end
end
