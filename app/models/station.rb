class Station < ActiveRecord::Base

  # Spalten in der csv Datei vom dwd:
  # Stations_id       -> stations_id
  # Stationsname      -> name
  # geograph.Breite   -> latitude
  # geograph.Laenge   -> longitude
  # Stationshoehe     -
  # Naturraumgruppe   -
  # Naturraum         -
  # Datum Stationsaufloesung -
  # Bundesland        -

  def self.closest(geolocation={})
    latitude  = geolocation[:latitude]
    longitude = geolocation[:longitude]

    unless latitude && longitude
      return
    end

    dist = 1000000000
    closest = nil

    Station.find_each do |station|
      distance = station.distance(geolocation)

      if distance < dist
        dist = distance
        closest = station
      end
    end

    closest
  end

  def distance(geolocation)
    distance = Math.sqrt(((geolocation[:longitude] - longitude) ** 2) + ((geolocation[:latitude] - latitude) ** 2))
    distance
  end
end
