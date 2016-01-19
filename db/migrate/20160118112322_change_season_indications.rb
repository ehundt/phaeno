class ChangeSeasonIndications < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.string :name
    end

    remove_column :season_indications, :indicator_id
    add_reference :season_indications, :plant_id, index: true
    add_reference :season_indications, :season_id, index: true
  end
end
