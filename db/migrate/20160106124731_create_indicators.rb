class CreateIndicators < ActiveRecord::Migration
  # Beschreibung_Pflanze_Obst.txt
  def change
    create_table :indicators do |t|
      t.integer :object_id, null: false
      t.string  :name,      null: false
      t.timestamps
    end
  end
end
