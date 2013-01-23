application_config = YAML.load(File.open(File.join("config", "deployment.yml")))

server application_config["server_ip"].to_s, :app, :web, :db, primary:true
set :rails_env, "production"