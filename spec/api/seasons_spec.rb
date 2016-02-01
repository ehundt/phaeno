require 'rails_helper'

describe Seasons::API do
  describe "GET /api/v1/seasons/current with geolocation params" do
    let!(:phaenological_season) { PhaenologicalSeason.create({
      station_id: 1,
      start:      (Date.today - 3.days),
      active:     true,
      season:     :vollfrühling
    }) }

    before(:each) do
      allow(PhaenologicalSeason).to receive(:current).and_return(phaenological_season)

      get '/api/v1/seasons/current',
        { :latitude  => 234553,
          :longitude => 9843 }
    end

    it { expect(response.status).to eq(200) }
    it "returns the current season at this location" do
      expected = { season:      "Vollfrühling",
                   description: "bla"
                 }
       expect(response.body).to eq(expected.to_json)
    end
  end

  describe "GET /api/v1/seasons/current fails without geolocation params" do
    before(:each) do
      get '/api/v1/seasons/current'
    end

    it { expect(response.status).to eq(400) }
  end
end
