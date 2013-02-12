## Fast Food

Fast Food is way to easily setup a fresh server with a complete Rails stack.

It installs Ruby, Git, MySql, Apache, Passenger and Imagemagick.

## Installation    

```ruby
gem 'fast_food', :git => 'git@github.com:rkjbnz/fast_food.git'
```

Run the bundle command to install it.

After you install fast_food and add it to your Gemfile, you need to run the rake task:

```console
rake deployment:setup
```

Follow the prompts, you will be asked to supply:

Application Name: `myapp`
Repository Path: `user@server:/path/to/repo.git`
Domain Name: `myapp.com`
Server ip address

## Usage

    # Run this task to setup your initial configuration. This can be run on a completely fresh server
    # It installs and sets up ruby, git, mysql, apache, passenger and imagemagick. You will need your server ip address. Everything is done as root.
    # (tested on ubuntu 10.04, 11.04 you might have to change the deploy.rb file for different versions and distros)
    
    rake deployment:setup (Follow the prompts)
    
    # After filling out the details run
    
    cap setup:go
    
    #done!
    # If you haven't configured your DNS add a line to your hosts file for the domain name and ip address you entered at the prompt
