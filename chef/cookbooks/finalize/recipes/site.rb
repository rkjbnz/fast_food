include_recipe "apache2"

web_app node['config']['name'] do
  server_name node['config']['server_name']
  server_aliases node['config']['server_aliases']
  docroot node["config"]["docroot"]
end