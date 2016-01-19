namespace :seasons do

  require 'net/ftp'
  require 'zip'
  require 'csv'

  TEMP_DIR = "/tmp/dwd"

  desc "Retrieve phaenological data from Deutscher Wetterdienst via ftp"
  task :retrieve_data => :environment do

    unless File.exists?(TEMP_DIR)
      Dir.mkdir(TEMP_DIR)
      puts "Creating new directory: #{TEMP_DIR}"
    end

    filenames = [ "Sofortmelder_Landwirtschaft_Kulturpflanze",
                  "Sofortmelder_Wildwachsende_Pflanze",
                  "Sofortmelder_Obst"]

    # TODO: remove this line:
    #filenames = [ "Sofortmelder_Landwirtschaft_Kulturpflanze" ]

    ftp = Net::FTP.new('ftp-outgoing2.dwd.de')
    ftp.login(user = "gds14012", passwd = "BVxNFsJo")

    ftp.chdir('gds/specials/climate/tables/germany')

    filenames.each do |filename|
      ftp.getbinaryfile(filename + "_akt.zip",
                      TEMP_DIR + "/" + filename + ".zip", 1024)
    end
    ftp.quit()
  end

  desc "Extract downloaded ftp season data"
  task :extract_latest_data => :environment do
    config = YAML.load_file("#{Rails.root.to_s}/config/season_data.yml")

    zip_filenames = {}
    ["culture", "wild", "fruits"].each do |type|
      zip_filenames[type] = "#{TEMP_DIR}/" + config["season_data"][type]["zip_filename"]
    end

    zip_filenames.each do |type, zip|

      dest_dir = "dwd/#{type}"
      unless File.exists?(dest_dir)
        Dir.mkdir(dest_dir)
        puts "Creating new directory: #{dest_dir}"
      end

      Zip::File.open(zip) do |zip_file|
        puts "Importing phases #{zip_file.inspect}"

        zip_file.each do |data|
          puts "Extractig #{data.name}"
# TODO: files must be stored on amazon s3 or maybe its possible to store it
# in amazon tmp folder
          data.extract("#{dest_dir}/#{data.name}")
        end
      end
    end
    # TODO: remove files in tmp directory?
  end

  namespace :stations do
    desc "Import stations data"
    task :import => :environment do
      import_data("stations")
    end
  end

  namespace :season_indications do
    desc "Import season indication data"
    task :import => :environment do
      config = YAML.load_file("#{Rails.root.to_s}/config/season_data.yml")

      config["seasons"].each do |season, indicators|
        indicators.each do |indicator|
          plant = Plant.where(name: indicator["name"]).first
          phase = Phase.where(name: indicator["phase"]).first
          season_obj = Season.where(name: season).first
          params = { plant_id:  plant.id,
                     phase_id:  phase.id,
                     season_id: season_obj.id }

          if plant && phase && season_obj
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
            puts "season_obj = #{season_obj.inspect}"
            puts
          end
        end
        puts
      end
    end
  end

  namespace :data do
    desc "Import season data from already extracted files"
    task :import => :environment do |t|

    end
  end

  desc "Import data from extracted zip files from dwd"
  task :import, [:what] => [:environment] do |t, args|
    case args[:what]
    when "stations"
      import_data("stations")
    when "phases"
      import_data("phases")
    when "season_data"
      ["wild", "fruits", "culture"].each do |type|
        import_data(args[:what], type)
      end
    when "plants"
      ["wild", "fruits", "culture"].each do |type|
        import_data(args[:what], type)
      end
    end
  end

private
  def import_data(what, type="wild")
    puts "Importing #{what} data (type = #{type}): "
    config = YAML.load_file("#{Rails.root.to_s}/config/season_data.yml")
    # qualitätsniveau: nicht 0 (testdaten), nicht 13, nicht 14

    if what == "season_data"
      # filenames = "dwd/" + config["season_data"][type]["season_data_filenames"]
      config["season_data"][type]["season_data_filenames"].each do |filename|
        if import_csv("dwd/#{type}/" + filename, what)
          puts "\nImport of #{what} (#{type}) done."
        else
          puts "\nImport of #{what} (#{type}) failed!"
        end
      end
    else
      # so far the files for stations and for phases are the same for all
      # types
      filename = "dwd/#{type}/" + config["season_data"][type]["#{what}_filename"]
      if import_csv(filename, what)
        puts "Import of #{what} (#{type}) done.\n"
      else
        puts "Import of #{what} (#{type}) failed!\n"
      end
    end
  end

  def import_csv(filename, what)
    puts "Importing data from #{filename}"
    first_line = true
    keys = []

    begin
      CSV.open(filename, "rb:ISO-8859-1", { :col_sep => ";" }) do |file|
        file.each do |row|
          if first_line
            keys = row.to_a.select{ |k| k && /eor/ !~ k }.collect { |k| k.downcase.strip }
            puts keys.inspect
          else
            values = row.to_a.select{ |k| k && /eor/ !~ k }.collect { |v| v.strip }
            orig_data = Hash[keys.zip(values)]

            case what
            when "stations"
              store_stations_data(orig_data)
            when "phases"
              store_phase_data(orig_data)
            when "season_data"
              store_season_data(orig_data)
            when "plants"
              store_plants_data(orig_data)
            end

          end
          first_line = false
        end
      end
    # rescue Errno::ENOENT => e
    #   puts "ERROR: #{e.message}"
    #   return false
    # rescue CSV::MalformedCSVError
    #   puts "ERROR: #{CSV::MalformedCSVError.inspect}"
    #   return false
    # rescue StandardError => e
    #   puts "ERROR: #{e.message}"
    #   return false
    end
    return true
  end

  def store_plants_data(orig_data)
    data = {}
    data["dwd_object_id"] = orig_data["pflanzengruppe,-objekt"]
    data["name"] = orig_data["bezeichnung"]

    if data["name"]
      plant = Plant.where(dwd_object_id: data["dwd_object_id"]).first_or_create(data)
      print plant.name + ", "
    end
  end

  def store_stations_data(orig_data)
    data = {}
    data["stations_id"] = orig_data["stations_id"]
    data["latitude"]    = orig_data["geograph.breite"]
    data["longitude"]   = orig_data["geograph.laenge"]
    data["name"]        = orig_data["stationsname"]

    if (data["stations_id"].to_i > 0)
      station = Station.where(stations_id: data["stations_id"]).first_or_create(data)
      print "#{station.id}, "
    end
  end

  def store_phase_data(orig_data)
    data = {}
    data["phase_id"] = orig_data["phasen_id"]
    data["name"]     = orig_data["phasenbezeichnung"]

    if (data["phase_id"].to_i > 0)
      phase = Phase.where(phase_id: data["phase_id"]).first_or_create(data)
      print "#{phase.name}, "
    end
  end

  def store_season_data(data)
    puts data.inspect
      params = {}
      params["station_id"] = data["stations_id"].to_i
      params["phase_id"]   = data["phase_id"].to_i
      params["plant_id"]   = data["plant_id"].to_i
      params["date"]       = data["eintrittsdatum"]
      season = PhaenologicalSeason.new(params)
      puts season.inspect
  end
end
        # TODO: only indicators needed for next seasons
        # get filenames from indicators
#        puts "Forsythie"
 #       import_season_data(zip_file.glob('PH_Sofortmelder_Wildwachsende_Pflanze_Forsythie.txt').first)
