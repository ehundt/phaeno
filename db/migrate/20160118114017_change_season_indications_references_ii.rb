class ChangeSeasonIndicationsReferencesIi < ActiveRecord::Migration
  def change
    remove_column :season_indications, :season
  end
end
