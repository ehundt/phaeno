class SeasonIndication < ActiveRecord::Base
  has_one :plant
  has_one :phase
  belongs_to :phaenological_season
end
