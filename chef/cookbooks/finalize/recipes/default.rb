include_recipe "imagemagick"
include_recipe "imagemagick::devel"
include_recipe "database::mysql"

# create a mysql database
mysql_database node['config']['database'] do
  connection ({:host => node['config']['hostname'], :username => "root", :password => node['mysql']['server_root_password']})
  action :create
end

mysql_database_user node['config']['username'] do
  connection ({:host => node['config']['hostname'], :username => "root", :password => node['mysql']['server_root_password']})
  password node['config']['password']
  action :create
end

mysql_database_user node['config']['username'] do
  connection ({:host => node['config']['hostname'], :username => "root", :password => node['mysql']['server_root_password']})
  password node['config']['password']
  action :grant
end