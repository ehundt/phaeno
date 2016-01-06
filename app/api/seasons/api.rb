module Seasons
  class API < Grape::API
    version 'v1', using: :path # http://localhost:3000/api/v1/seasons/germany
    format :json
    prefix :api

    resource :seasons do
     params do
       requires :geolocation, type: String, desc: 'Geolocation'
     end
      desc 'Gives me the average phaenological season in Germany'
      get :germany do
        response = { bla: "got geolocation #{params[:geolocation]}" }
        response.to_json
      end
    end
  end
end
