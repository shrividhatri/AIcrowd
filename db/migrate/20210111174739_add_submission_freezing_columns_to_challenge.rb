class AddSubmissionFreezingColumnsToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :submission_lock_time, :datetime
    add_column :challenges, :submission_lock_enabled, :boolean, default: false
    add_column :challenges, :submission_filter, :text
  end
end
