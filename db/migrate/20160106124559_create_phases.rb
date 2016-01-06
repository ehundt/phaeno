class CreatePhases < ActiveRecord::Migration
  # Beschreibung_Phase.txt
  def change
    create_table :phases do |t|
      t.integer :phase_id
      t.string  :name

      t.timestamps
    end
  end
end
