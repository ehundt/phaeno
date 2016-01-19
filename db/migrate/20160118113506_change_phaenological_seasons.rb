class ChangePhaenologicalSeasons < ActiveRecord::Migration
  def change
    remove_column :phaenological_seasons, :season
    add_reference :phaenological_seasons, :season, index: true
  end
end
