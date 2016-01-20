class PhaenologicalSeason < ActiveRecord::Base

  has_one :station

  def self.current_season_id(geolocation)
    #latitude = geolocation["latitude"]
    #longitude = geolocation["longitude"]

    station = Station.closest(geolocation)
    ph_season = self.where(station: 5).order_by(:start)
    return Season.find(ph_season.season_id)
  end
end

# an der station wurde diese phase bei der pflanze beobachtet am datum

# station_id
# phase_id
# plant_id
# date
