class SeasonIndication < ActiveRecord::Base
  has_one :indicator
  has_one :phase
  belongs_to :phaenological_season
end
