namespace :dwd do

  require 'net/ftp'
  require 'zip'
  require 'csv'
  require 'fileutils'

  namespace :season_indications do
    desc "Import season indication data"
    task :import => :environment do
      config = YAML.load_file("#{Rails.root.to_s}/config/season_data.yml")

      config["seasons"].each do |season, indicators|
        indicators.each do |indicator|
          plant = Plant.where(name: indicator["name"]).first
          phase = Phase.where(name: indicator["phase"]).first
          params = { plant_id:  plant.id,
                     phase_id:  phase.id,
                     season:    season.downcase }

          if plant && phase && season
            season_indication = SeasonIndication.where(params).first
            unless season_indication
              success = SeasonIndication.create(params)
              puts "#{season} with #{plant.name} created."
            else
              season_indication.update(params)
              puts "#{season} with #{plant.name} updated."
            end
          else
            puts "#{season}: #{plant.name} could not be imported:"
            puts "plant = #{plant.inspect}"
            puts "phase = #{phase.inspect}"
            puts "season = season"
            puts
          end
        end
        puts
      end
    end
  end
end
