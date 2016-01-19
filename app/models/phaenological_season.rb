class PhaenologicalSeason < ActiveRecord::Base

  has_one :station
end

# an der station wurde diese phase bei der pflanze beobachtet am datum

# station_id
# phase_id
# plant_id
# date
