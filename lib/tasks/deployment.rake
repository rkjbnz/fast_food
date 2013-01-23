namespace :deployment do

  require 'yaml'
  require 'json'

  desc "Configures your application for initial deployment. Inserts database and deployment configuration."
  task :setup do
    spec = Gem::Specification.find_by_name("fast_food")
    gem_root = spec.gem_dir
    
    `mkdir -p #{Rails.root}/chef && cp -R #{gem_root}/chef/* #{Rails.root}/chef && cp -R #{gem_root}/config/* #{Rails.root}/config`
    
    print "\n\nPlease enter an application name (one word, or use underscores): "
    application_name = tidy_input(STDIN.gets)
    
    print "\nPlease enter a repository path: "
    repository_path = tidy_input(STDIN.gets)
    
    print "\nPlease enter a domain name: "
    domain_name = tidy_input(STDIN.gets)
    
    print "\nPlease enter the ip address of your server: "
    server_ip = tidy_input(STDIN.gets)
    
    database_name = application_name + "_production"
    application_config = YAML.load(File.open(File.join("config", "deployment.yml")))
    database_config = YAML.load(File.open(File.join("config", "database.yml")))

    # Add application name and repository URL into deployment config.
    if application_config["application"].eql?("REPLACE_ME")
      puts "INSERTED: Deployment configuration"

      application_config["application"] = application_name.gsub /_/, "-"
      application_config["repository"] = repository_path
      application_config["domain"] = domain_name
      application_config["server_ip"] = server_ip
      File.open(File.join("config", "deployment.yml"), "w+") do |file|
        YAML.dump(application_config, file)
      end
    else
      puts "IGNORED: Deployment configuration"
    end

    # Add production database details.
    if database_config["production"]["database"].nil? || database_config["production"]["database"]
      puts "INSERTED: Database details"

      database_config["production"]["database"] = database_name
      database_config["production"]["username"] = application_name[0, 16]
      database_config["production"]["password"] = random_characters
      File.open(File.join("config", "database.yml"), "w+") do |file|
        YAML.dump(database_config, file)
      end
    else
      puts "IGNORED: Database details"
    end
    
    # Add Chef JSON details
    server_production_hash = { 
      "config" => {
        "host" => "localhost",
        "database" => "#{database_config["production"]["database"]}",
        "username" => "#{database_config["production"]["username"]}",
        "password" => "#{database_config["production"]["password"]}"
      },
      "mysql_root_password" => "#{random_characters(12)}",
      "run_list" => [ "role[mysql]","role[rvm]","role[passenger]","recipe[finalize]" ]
    }
    File.open(File.join("chef", "server_production.json"), "w+") do |f|
      f.write(server_production_hash.to_json)
    end
    
    production_hash = { 
      "config" => {
        "name" => "#{application_name}",
        "server_name" => "www.#{domain_name}",
        "server_aliases" => [ "#{domain_name}" ],
        "docroot" => "/var/www/#{application_name}/current/public"
      },
      "run_list" => [ "recipe[finalize::site]" ]
    }
    File.open(File.join("chef", "production.json"), "w+") do |f|
      f.write(production_hash.to_json)
    end

    puts "\nDone! Now commit your changes and run this: cap server_production setup:server\n\n"
  end

  # Random alphanumeric characters.
  def random_characters(size=8)
    alphanumerics = [('0'..'9'),('A'..'Z'),('a'..'z')].map {|range| range.to_a}.flatten
    (1..size).map { alphanumerics[Kernel.rand(alphanumerics.size)] }.join
  end

  # Transforms input into something the config can use.
  def tidy_input(application_name)
    input = application_name.chomp.downcase
    input.gsub! /[^a-zA-Z0-9_\-\.\:\/\@]/, ''
    input.gsub! /[\s\-]/, '_'
    input
  end

end