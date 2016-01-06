class CreatePhaenologicalSeasons < ActiveRecord::Migration
  def change
    create_table :phaenological_seasons do |t|
      t.integer :season,     null: false
      t.integer :station_id, null: false
      t.date    :start
      t.date    :stop
      t.boolean :active,     null: false

      t.timestamps
    end

    # INDEX!?
  end
end
