require "bundler/capistrano"
require 'capistrano/ext/multistage'
require "yaml"

application_config = YAML.load(File.open(File.join("config", "deployment.yml")))

set :stages, %w(server_production production)
set :default_stage, "production"

default_run_options[:pty] = true 
ssh_options[:forward_agent] = true

set :ruby_string, "ruby-1.9.3-p374"

set :application, application_config["application"]
set :repository,  application_config["repository"]
set :deploy_to, "/var/www/#{application_config["application"]}"
set :branch, "master"


set :scm, :git
set :scm_verbose, true
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_via, :remote_cache
set :use_sudo, true
set :keep_releases, 3
set :user, "root"

set :chef_binary, "/usr/local/bin/chef-solo"

load 'deploy/assets'

namespace :deploy do
  task :start do ; end
  task :stop do ; end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

end

namespace :bootstrap do
  
  task :init do
    run("apt-get -y update")
    run("apt-get -y install build-essential zlib1g-dev libssl-dev libreadline5-dev libyaml-dev")
    run("wget ftp://ftp.ruby-lang.org/pub/ruby/1.9/#{ruby_string}.tar.gz")
    run("tar -xvzf #{ruby_string}.tar.gz")
    run("cd #{ruby_string} && ./configure --prefix=/usr/local")
    run("cd #{ruby_string} && make")
    run("cd #{ruby_string} && make install")
    run("gem install chef bundler --no-ri --no-rdoc")
    run("rm -rf /var/chef")
    system("tar czf 'chef.tar.gz' -C chef/ .")
    upload("chef.tar.gz", "/var/", :via => :scp)
    run("mkdir -p /var/chef")
    run("cd /var/ && sudo tar xzf 'chef.tar.gz' -C /var/chef")
  end
  
end

namespace :chef do
  task :default do
    sudo("/bin/bash -c 'cd /var/chef && #{chef_binary} -c solo.rb -j #{stage}.json'")
  end
  
  task :finalize do
    sudo("/bin/bash -c 'cd /var/chef && #{chef_binary} -c solo.rb -j #{stage}.json'")
    sudo("rm -rf /var/chef.tar.gz")
    sudo("rm -rf /var/chef")
  end
end


namespace :setup do
  
  task :server do
    transaction do
      bootstrap.init
      chef.default
    end
  end
  
  task :site do
    deploy.setup
    deploy.cold
    chef.finalize
  end
  
end
