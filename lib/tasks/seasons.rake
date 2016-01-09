namespace :seasons do

  require 'net/ftp'
  require 'zip'
  require 'csv'

  desc "Retrieve phaenological data from Deutscher Wetterdienst via ftp"
  task :retrieve_data => :environment do

    temp_dir = "/tmp/dwd"
    unless File.exists?(temp_dir)
      Dir.mkdir(temp_dir)
      puts "Creating new directory: #{temp_dir}"
    end

    filenames = [ "Sofortmelder_Landwirtschaft_Kulturpflanze",
                  "Sofortmelder_Wildwachsende_Pflanze",
                  "Sofortmelder_Obst"]

    # TODO: remove this line:
    filenames = [ "Sofortmelder_Landwirtschaft_Kulturpflanze" ]

    ftp = Net::FTP.new('ftp-outgoing2.dwd.de')
    ftp.login(user = "gds14012", passwd = "BVxNFsJo")

    ftp.chdir('gds/specials/climate/tables/germany')

    filenames.each do |filename|
      ftp.getbinaryfile(filename + "_akt.zip",
                      temp_dir + "/" + filename + ".zip", 1024)
    end
    ftp.quit()
  end
#    config = YAML.load("season_data")



    # zip_filenames = [ "#{temp_dir}/Sofortmelder_Wildwachsende_Pflanze_#{datetime}.zip",
    #               "#{temp_dir}/Sofortmelder_Landwirtschaft_Kulturpflanze_#{datetime}.zip",
    #               "#{temp_dir}/Sofortmelder_Obst_#{datetime}.zip"
    #             ]

  desc "Extract downloaded ftp season data"
  task :extract_latest_data => :environment do
    temp_dir = "/tmp/dwd"
    config = YAML.load_file("#{Rails.root.to_s}/config/season_data.yml")

    filenames = config["season_data"]["zip_filenames"]

    # TODO: remove this line:
    filenames = [ "Sofortmelder_Landwirtschaft_Kulturpflanze" ]

    zip_filenames = filenames.map { |file| "#{temp_dir}/#{file}.zip" }

    zip_filenames.each do |zip|

      Zip::File.open(zip) do |zip_file|
        puts "Importing phases #{zip_file.inspect}"

        zip_file.each do |data|
          puts "Extractig #{data.name}"
          data.extract("dwd/#{data.name}")

          #begin
#            import_data(data)
#          rescue => ex
            #logger.error ex.message
  #          puts "ERROR: #{ex.message}"
 #         end
        end
      end
    end
    # TODO: remove files in tmp directory?
  end

  desc "Import data from extracted zip files from dwd"
  task :import => :environment do
    temp_dir = "/tmp/dwd"
    config = YAML.load_file("#{Rails.root.to_s}/config/season_data.yml")

    filename = "dwd/" + config["season_data"]["stations"]["filename"]
    import_data(filename)

  end

private

  def import_phases(data)
    puts data.get_input_stream.read
  end

  def import_data(filename)
    # qualitätsniveau: nicht 0 (testdaten), nicht 13, nicht 14

    first_line = true
    keys = []

    begin
      CSV.open(filename, "rb:ISO-8859-1", { :col_sep => ";" }) do |file|
        file.each do |row|
          if first_line
            keys = row.to_a.collect { |k| k.downcase.strip }
          else
            values = row.to_a
            orig_data = Hash[keys.zip(values)]

            data = {}
            data["stations_id"] = orig_data["stations_id"]
            data["latitude"]    = orig_data["geograph.breite"]
            data["longitude"]   = orig_data["geograph.laenge"]
            data["name"]        = orig_data["stationsname"]

# TODO: update instead of new!
            station = Station.new(data) if data["stations_id"]
            station.save
            puts station.inspect
          end
          first_line = false
        end
      end
    rescue CSV::MalformedCSVError
      puts "ERROR: #{CSV::MalformedCSVError.inspect}"
    end
  end

  def import_season_data(data)

    # Read into memory
    #content = data.get_input_stream.read
    # qualitätsniveau: nicht 0 (testdaten), nicht 13, nicht 14

#    CSV.foreach("dwd/#{data.name}") do |row|
#      puts row.inspect
#    end
  end
end
#        import_phases(zip_file.glob('Beschreibung_Phase.txt').first)

#        puts "Importing stations"
#        import_stations(zip_file.glob('Beschreibung_Stationen.txt').first)

#        puts "Importing season data: "

        # TODO: only indicators needed for next seasons
        # get filenames from indicators
#        puts "Forsythie"
 #       import_season_data(zip_file.glob('PH_Sofortmelder_Wildwachsende_Pflanze_Forsythie.txt').first)
