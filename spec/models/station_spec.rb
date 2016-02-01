require "spec_helper"

describe Station do
  context "precise geolocation of a station is given" do
    let!(:geolocation) { { latitude:       53.65,
                          longitude:      10.1833 } }
    let!(:station) { Station.create( { dwd_station_id: 1,
                                       name: "Hamburg-Volksdorf (Ph)"
                                    }.merge(geolocation) ) }
    # let!(:phaenological_season) { PhaenologicalSeason.create({
    #   station_id: station.id,
    #   start:      (Date.today - 3.days),
    #   active:     true,
    #   season:     :vorfrühling
    #   }) }

    it "returns the closest station to the given geolocation" do
      puts station.inspect

      closest_station = Station.closest({ latitude:  53.65,
                                          longitude: 10.1833 })
      expect(closest_station).to eql station
    end
  end
end
