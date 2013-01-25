# Fast Food

## Installation    

    gem "fast_food", :git => "git@github.com:rkjbnz/fast_food.git"
    
    bundle install (bundle update if you run into a dependancy issue)

## Usage

    # Run this task to setup your initial configuration. This can be run on a completely fresh server
    # It installs and sets up ruby, git, mysql, apache, passenger and imagemagick. You will need your server ip address. Everything is done as root.
    # (tested on ubuntu 10.04, 11.04 you might have to change the deploy.rb file different versions and distros)
    
    rake deployment:setup (Follow the prompts)
    
    # After filling out the details run
    
    cap server_production setup:server
    
    cap setup:site
    
    #done!
    # If you haven't configured your DNS add a line to your hosts file for the domain name and ip address you entered at the prompt