# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)
#run Rails.application


require ::File.expand_path('../app/api/seasons/api.rb', __FILE__)
run Seasons::API
