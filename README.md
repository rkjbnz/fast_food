# Fast Food

Fast Food is a way to easily setup a fresh server with a complete Rails stack and deploy your application.

It installs Ruby, Git, MySql, Apache, Passenger and Imagemagick.

## Installation    

```ruby
gem 'fast_food', :git => 'git@github.com:rkjbnz/fast_food.git'
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

## Complete

This task will install Ruby and some initial Gems then use Chef-solo to setup the server. After this is done it will do a standard cap deploy:cold and then seed the db. Once the app is deployed, Chef-Solo will then configure the Passenger-Apache vhost.

You can run the deployment task as much as you want, though it will try and install the full stack every time and it will seed the db (if you use a seeds file)

If you make changes to your app you can just use the standard Capistrano tasks `cap deploy:update` and `cap deploy:migrate` to deploy changes.

If you haven't configured your DNS add a line to your hosts file for the domain name and ip address you entered at the prompt

It does everything as root, if this is not ideal setup another user on your server and change the `deploy.rb` file

If you run into errors it could be an issue with the Chef-solo recipe for the particular server you have setup. You can change out recipes or add new ones by dropping them into the chef/cookbooks folder and updating the runlist in the `chef/production.json` file.

Hey this is fast food after all not fine dining!

## Todo

* Support for more server versions and distros. Only tested on Ubuntu 10.04 and Ubuntu 12.10. For 12.10 you will have to alter the `ubuntu.sh` file in the config/deploy folder and replace the package `libreadline5-dev` with `libreadline-gplv2-dev lib64readline-gplv2-dev`
* Support for multiple stages
* Support for different server roles
* Setup other services such as backups to server/s3
