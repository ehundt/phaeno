class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.integer :stations_id, null: false
      t.string  :name
      t.float   :latitude
      t.float   :longitude

      t.timestamps
    end
  end
end
