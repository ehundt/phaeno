class PhaenologicalSeason < ActiveRecord::Base

  has_one :station

  enum season: [ :vorfrühling, :erstfrühling, :vollfrühling,
                 :frühsommer, :hochsommer, :spätsommer,
                 :frühherbst, :vollherbst, :spätherbst, :winter ]

  def self.current_season(geolocation)
    #latitude = geolocation["latitude"]
    #longitude = geolocation["longitude"]

    station = Station.closest(geolocation)
    ph_season = self.where(station: 5).order_by(:start)
    return ph_season.season
  end
end

# an der station wurde diese phase bei der pflanze beobachtet am datum

# station_id
# phase_id
# plant_id
# date
