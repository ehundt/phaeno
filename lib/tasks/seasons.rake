namespace :seasons do

  require 'net/ftp'
  require 'zip'

  desc "Retrieve phaenological data from Deutscher Wetterdienst"
  task :retrieve_data => :environment do

    # temp_dir = "tmp/dwd_" + DateTime.now.strftime(format='%d_%m_%Y_%H_%M')
    temp_dir = "/Users/elisabethhundt/dwd"
    # Dir.mkdir(temp_dir) unless File.exists?(temp_dir)
    # puts "Creating new directory: #{temp_dir}"

    # ftp = Net::FTP.new('ftp-outgoing2.dwd.de')
    # ftp.login(user = "gds14012", passwd = "BVxNFsJo")

    # files = ftp.chdir('gds/specials/climate/tables/germany')
    # ftp.getbinaryfile("Sofortmelder_Landwirtschaft_Kulturpflanze.zip",
    #                   temp_dir + "/Sofortmelder_Landwirtschaft_Kulturpflanze.zip", 1024)
    # ftp.quit()

    #config = YAML.load("season_data")
    zip_filenames = [ "#{temp_dir}/Sofortmelder_Wildwachsende_Pflanze.zip"
                 #,
                 # "#{temp_dir}/Sofortmelder_Landwirtschaft_Kulturpflanze.zip",
                 # "#{temp_dir}/Sofortmelder_Obst.zip"
                ]

    zip_filenames.each do |zip|

      Zip::File.open(zip) do |zip_file|
        puts "Importing phases"
        #import_phases(zip_file.glob('Beschreibung_Phase.txt').first)

        puts "Importing stations"
        #import_stations(zip_file.glob('Beschreibung_Stationen.txt').first)

        puts "Importing season data: "

        # TODO: only indicators needed for next seasons
        # get filenames from indicators
        puts "Forsythie"
        import_season_data(zip_file.glob('PH_Sofortmelder_Wildwachsende_Pflanze_Forsythie.txt').first)
      end
    end
    # TODO: remove files in tmp directory?
  end

private

  def import_phases(data)
    puts data.get_input_stream.read
  end

  def import_stations(data)
    puts data.get_input_stream.read
  end

  def import_season_data(data)
    puts data.get_input_stream.read
    # qualitätsniveau: nicht 0 (testdaten), nicht 13, nicht 14
  end
end
