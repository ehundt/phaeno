class ChangeSeasonIndicationsReferences < ActiveRecord::Migration
  def change
    remove_column :season_indications, :plant_id_id
    remove_column :season_indications, :season_id_id
    add_reference :season_indications, :plant, index: true
    add_reference :season_indications, :season, index: true
  end
end
