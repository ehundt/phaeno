class ChangeDwdIds < ActiveRecord::Migration
  def change
    rename_column :stations, :stations_id, :dwd_station_id
    rename_column :phases, :phase_id, :dwd_phase_id
  end
end
