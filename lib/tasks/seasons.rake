namespace :dwd do

  require 'net/ftp'
  require 'zip'
  require 'csv'
  require 'fileutils'

  temp_dir = "/tmp/dwd"

  desc "Retrieve and import newest season data"
  task :update_season_data => :environment do
    # if it should be invoked even if it has already been then use:
    # Rake::Task["retrieve_data"].reenable
    Rake::Task["retrieve_data"].invoke
    Rake::Task["extract_latest_data"].invoke
    Rake::Task["data:import"].invoke
  end

  desc "Retrieve phaenological data from Deutscher Wetterdienst via ftp"
  task :retrieve_data => :environment do

    unless File.exists?(temp_dir)
      Dir.mkdir(temp_dir)
      puts "Creating new directory: #{temp_dir}"
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
                      temp_dir + "/" + filename + ".zip", 1024)
    end
    ftp.quit()
  end

  desc "Extract downloaded ftp season data"
  task :extract_data => :retrieve_data do
    config = YAML.load_file("#{Rails.root.to_s}/config/season_data.yml")

    zip_filenames = {}
    ["culture", "wild", "fruits"].each do |type|
      zip_filenames[type] = "#{temp_dir}/" + config["season_data"][type]["zip_filename"]
    end

    zip_filenames.each do |type, zip|

      dest_dir = "#{temp_dir}/#{type}"
      if File.exists?(dest_dir)
        FileUtils.rm_rf("#{dest_dir}/.", secure: true)
      else
        Dir.mkdir(dest_dir)
        puts "Creating new directory: #{dest_dir}"
      end

      Zip::File.open(zip) do |zip_file|
        puts "Importing #{zip}"

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
    desc "Import stations data from extracted csv file"
    task :import => :extract_data do

      config = YAML.load_file("#{Rails.root.to_s}/config/season_data.yml")
      filename = "#{temp_dir}/wild/" + config["season_data"]["wild"]["stations_filename"]

      if import_csv(filename, "stations")
        puts "Import of stations (wild) done.\n"
      else
        puts "Import of stations (wild) failed!\n"
      end
    end
  end

  desc "Import stations, plants or phases from extracted zip files from dwd"
  task :import, [:what] => [:environment] do |t, args|
    case args[:what]
    when "stations"
      import_data("stations")
    when "phases"
      import_data("phases")
    when "plants"
      ["wild", "fruits", "culture"].each do |type|
        import_data(args[:what], type)
      end
    when "season_data"
      ["wild", "fruits", "culture"].each do |type|
        import_data(args[:what], type)
      end
    end
  end

private
  def import_data(what, type="wild")
    puts "Importing #{what} data (type = #{type}): "
    config = YAML.load_file("#{Rails.root.to_s}/config/season_data.yml")

    if what == "season_data"
      temp_dir = "/tmp/dwd"
      files = Dir["#{temp_dir}/#{type}/*"]

      #files = config["season_data"][type]["season_data_filenames"]

      files.each do |filename|
        if /Sofortmelder/ =~ filename && /Beschreibung/ !~ filename
          if import_csv(filename, what)
            puts "\nImport of #{what} (#{type}) done."
          else
            puts "\nImport of #{what} (#{type}) failed!"
          end
        end
      end
    else
      # so far the files for stations and for phases are the same for all
      # types
      filename = "#{temp_dir}/#{type}/" + config["season_data"][type]["#{what}_filename"]
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
              Import::Station.import(orig_data)
            when "phases"
              Import::Phase.import(orig_data)
            when "season_data"
              Import::PhaenologicalSeason.import(orig_data)
            when "plants"
              Import::Plant.import(orig_data)
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
end
