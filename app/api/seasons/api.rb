module Seasons
  class API < Grape::API
    version 'v1', using: :path # http://localhost:3000/api/v1/seasons/germany
    format :json
    prefix :api

    resource :seasons do
      before { Rails.logger.info "Request Body: #{request.body.read}" }

      params do
        requires :latitude, type: String, desc: 'latitude'
        requires :longitude, type: String, desc: 'longitude'
      end

      desc 'Gives me the phaenological season at the given geolocation today'
      get :current do
        geolocation = { latitude:  params[:latitude],
                        longitude: params[:longitude] }

        ph_season = PhaenologicalSeason.current(geolocation)

        if ph_season
          response = { season:      ph_season.season.humanize,
                       description: "bla" }
        else
          response = {}
        end
      end
    end
  end
end
