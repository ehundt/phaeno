module Seasons
  class API < Grape::API
    version 'v1', using: :path # http://localhost:3000/api/v1/seasons/germany
    format :json
    prefix :api

    resource :seasons do
     params do
       requires :geolocation, type: String, desc: 'Geolocation'
     end
      desc 'Gives me the phaenological season at the given geolocation today'
      get :current do
        response = { bla: "got geolocation #{params[:geolocation]}" }
        response.to_json
      end
    end
  end
end
