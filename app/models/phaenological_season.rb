class PhaenologicalSeason < ActiveRecord::Base

  has_one :station

  enum season: [ :vorfrühling, :erstfrühling, :vollfrühling,
                 :frühsommer, :hochsommer, :spätsommer,
                 :frühherbst, :vollherbst, :spätherbst, :winter ]

  def self.current(geolocation={})
    station = Station.closest(geolocation)

    unless station
      return nil
    end

    ph_season = self.where(station: station.id).order_by(:start)
    return ph_season
  end
end

# an der station wurde diese phase bei der pflanze beobachtet am datum

# station_id
# phase_id
# plant_id
# date
