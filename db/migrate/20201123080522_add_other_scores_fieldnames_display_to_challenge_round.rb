class AddOtherScoresFieldnamesDisplayToChallengeRound < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_rounds, :other_scores_fieldnames_display, :string
  end
end
