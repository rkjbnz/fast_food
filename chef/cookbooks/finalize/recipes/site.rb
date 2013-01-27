include_recipe "apache2"

web_app node['site']['name'] do
  server_name node['site']['server_name']
  server_aliases node['site']['server_aliases']
  docroot node["site"]["docroot"]
end