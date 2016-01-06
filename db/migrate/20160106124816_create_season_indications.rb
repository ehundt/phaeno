class CreateSeasonIndications < ActiveRecord::Migration
  def change
    create_table :season_indications do |t|
      t.integer :indicator_id, null: false
      t.integer :phase_id,     null: false
      t.integer :season,       null: false
    end
  end
end
