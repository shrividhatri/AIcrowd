class UpdateOngoingLeaderboardsToVersion9 < ActiveRecord::Migration[5.2]
  def change
    update_view :ongoing_leaderboards, version: 9, revert_to_version: 8
  end
end
