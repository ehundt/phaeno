class Import::Station

  def self.import(orig_data)
    data = {}
    data["dwd_station_id"] = orig_data["stations_id"]
    data["latitude"]    = orig_data["geograph.breite"]
    data["longitude"]   = orig_data["geograph.laenge"]
    data["name"]        = orig_data["stationsname"]

    if (data["dwd_station_id"].to_i > 0)
      station = ::Station.where(dwd_station_id: data["dwd_station_id"]).first_or_create(data)
      print "#{station.id}, "
    end
  end
end
