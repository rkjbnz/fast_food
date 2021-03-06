include_recipe "imagemagick"
include_recipe "imagemagick::devel"
include_recipe "database::mysql"
include_recipe "git"
include_recipe "passenger_apache2"
include_recipe "passenger_apache2::mod_rails"

# create a mysql database
mysql_database node['mysql']['database'] do
  connection ({:host => node['mysql']['hostname'], :username => "root", :password => node['mysql']['server_root_password']})
  action :create
end

mysql_database_user node['mysql']['username'] do
  connection ({:host => node['mysql']['hostname'], :username => "root", :password => node['mysql']['server_root_password']})
  password node['mysql']['password']
  action :create
end

mysql_database_user node['mysql']['username'] do
  connection ({:host => node['mysql']['hostname'], :username => "root", :password => node['mysql']['server_root_password']})
  password node['mysql']['password']
  action :grant
end