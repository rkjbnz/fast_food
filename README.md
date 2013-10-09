# Fast Food

Fast Food is a way to easily setup a fresh server with a complete Rails stack and deploy your application.

It installs Ruby, Git, MySql, Apache, Passenger and Imagemagick.

## Requirements

fast food assumes you have a vps server setup, know the IP address and can login to it. Also a git repository setup somewhere which you will need to enter in during the rake setup phase.

During the standard deploy phase of capistrano it will try and compile the assets. It will error at this point if you do not have a js runtime setup, quickest thing to do is to add

```ruby
gem 'therubyracer', :platforms => :ruby
```

to your Gemfile in the assets group, this line might even be commented out, just uncomment it.

Because fast food uses mysql, it expects the mysql2 gem to be present in your gem file also.

## Installation    

```ruby
gem 'fast_food'
```

Run the bundle command to install it.

## Setup

After its installed run the rake task:

```console
rake fast_food:setup
```

Follow the prompts, you will be asked to supply:

Application Name: `myapp`

Repository Path: `user@server:/path/to/repo.git`

Domain Name: `myapp.com`

Server IP Address: `server ip`

After filling these out you should commit your changes.

## Deployment

To deploy the complete stack in one go run `cap fast_food:full` If you have your ssh keys setup on the server and repo location you won't have to do anything, the process should complete without intervention. If you haven't setup your keys you will need to enter in your password at various stages.

## Information

This task will install Ruby and some initial Gems then use Chef-solo to setup the server. After this is done it will do a standard cap deploy:cold and then seed the db. Once the app is deployed, Chef-Solo will then configure the Passenger-Apache vhost.

You can run the deployment task as much as you want, though it will try and install the full stack every time and it will seed the db (if you use a seeds file)

If you make changes to your app you can just use the standard Capistrano tasks `cap deploy:update` and `cap deploy:migrate` to deploy changes.

If you haven't configured your DNS add a line to your hosts file for the domain name and ip address you entered at the prompt

It does everything as root, if this is not ideal setup another user on your server and change the `deploy.rb` file

If you run into errors it could be an issue with the Chef-solo recipe for the particular server you have setup. You can change out recipes or add new ones by dropping them into the chef/cookbooks folder and updating the runlist in the `chef/production.json` file.

Hey this is fast food after all not fine dining!

## Installing Additional Cookbooks

If you want to install additional servers such as Memcached, you can just download the Chef cookbook and put it in the chef folder, update the runlist in the `chef/production.json` file then run `cap servers:install`

## Tested on

* Ubuntu 10.04 (For 10.04 you will have to alter the `ubuntu.sh` file in the config/deploy folder and replace the packages `libreadline-gplv2-dev lib64readline-gplv2-dev` with `libreadline5-dev`)
* Ubuntu 12.10 
* CentOS 6.3
* CentOS 5.8

I have found that if deploying to a x64 server if the server has minimal resources such as 512 ram it could run into errors installing some of the modules. Try increasing the resources or perhaps use a x32 server.

## Todo

* Support for more dbs
* Support for multiple stages
* Support for different server roles
* Setup other services such as backups to server/s3
