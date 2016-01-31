class SeasonIndication < ActiveRecord::Base
  has_one :plant
  has_one :phase
  belongs_to :phaenological_season

  enum season: [ :vorfrühling, :erstfrühling, :vollfrühling,
                 :frühsommer, :hochsommer, :spätsommer,
                 :frühherbst, :vollherbst, :spätherbst, :winter ]
end
