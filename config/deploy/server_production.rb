application_config = YAML.load(File.open(File.join("config", "deployment.yml")))
puts application_config["server_ip"].to_s
set :default_shell, "bash"
server application_config["server_ip"].to_s, :chef, :no_release => :true