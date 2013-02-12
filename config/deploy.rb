require "bundler/capistrano"
require 'capistrano/ext/multistage'
require "yaml"

application_config = YAML.load(File.open(File.join("config", "deployment.yml")))

set :default_stage, "production"
set :default_shell, "bash"

default_run_options[:pty] = true 
ssh_options[:forward_agent] = true

set :ruby_version, "ruby-1.9.3-p374"

set :application, application_config["application"]
set :repository,  application_config["repository"]
set :deploy_to, "/var/www/#{application_config["application"]}"
set :branch, "master"

set :scm, :git
set :scm_verbose, false

set :deploy_via, :remote_cache
set :use_sudo, true
set :keep_releases, 3
set :user, "root"

set :chef_binary, "/usr/local/bin/chef-solo"

load 'deploy/assets'

namespace :deploy do

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  task :seed do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end

end

namespace :bootstrap do
  
  task :init do
    run("rm -rf /var/chef")
    run("mkdir -p /var/chef")
    upload("config/deploy/ubuntu.sh", "/var/chef", :via => :scp)
    run("sudo bash /var/chef/ubuntu.sh #{ruby_version}")
    run("gem install net-ssh -v '~> 2.2.2' --no-ri --no-rdoc")
    run("gem install net-ssh-multi -v '1.1' --no-ri --no-rdoc")
    run("gem install net-ssh-gateway -v '1.1.0' --no-ri --no-rdoc")
    run("gem install chef -v '~> 10.18.2' --no-ri --no-rdoc")
    run("gem install bundler --no-ri --no-rdoc")
    system("tar czf 'chef.tar.gz' -C chef/ .")
    upload("chef.tar.gz", "/var/", :via => :scp)
    run("cd /var/ && sudo tar xzf 'chef.tar.gz' -C /var/chef")
    system("rm chef.tar.gz")
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
  
  task :go do
    transaction do
      bootstrap.init
      chef.default
      deploy.setup
      deploy.cold
      chef.finalize
    end
  end
  
end

after "deploy:cold", "deploy:seed"