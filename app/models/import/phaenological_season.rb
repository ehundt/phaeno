class Import::PhaenologicalSeason

    # "station_id", null: false
    # "start"
    # "stop"
    # "active",     null: false
    # "created_at"
    # "updated_at"
    # "season_id"

  def self.import(orig_data)
    data = {}
    # qualitätsniveau: nicht 0 (testdaten), nicht 13, nicht 14
    unless [0,13,14].include?(orig_data["qualitaetsniveau"].to_i)
      station = ::Station.where(dwd_station_id: orig_data["stations_id"].to_i).first
      unless station
        puts "Station not found! #{orig_data["dwd_station_id"]}"
        return
      end
      data["station_id"] = station.id

      plant = ::Plant.where(dwd_object_id: orig_data["objekt_id"].to_i).first
      unless plant
        puts "Plant #{orig_data["objekt_id"]} not found!"
        return
      end

      phase = ::Phase.where(dwd_phase_id: orig_data["phase_id"].to_i).first
      unless phase
        puts "Phase #{orig_data["phase_id"]} not found."
        return
      end

      # start, stop, active
      data["start"] = Date.parse(orig_data["eintrittsdatum"])
      data["active"] = true

      if season_indication = ::SeasonIndication.where(plant_id: plant.id, phase_id: phase.id).first
        data["season"] = season_indication.season
      else
        puts "SeasonIndication #{plant.name}: #{plant.id}, #{phase.name}: #{phase.id} not found!"
        return
      end

      if ::PhaenologicalSeason.where(data).count == 0
        ph_season = ::PhaenologicalSeason.create(data)
        puts "SUCCESS !!! Imported." if ph_season
      else
        puts "Season already in DB."
      end
    end
  end
end
