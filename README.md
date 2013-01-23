# Fast Food

## Installation    
    gem "fast_food", :git => "git@github.com:rkjbnz/fast_food.git"
    
    bundle install

## Usage

    # Run this task to setup your initial configuration. This can be run on a completely fresh ubuntu server, no ruby, git or anything. You will need your server ip address. Everything is done as root.
    
    rake deployment:setup (Follow the prompts)
    
    then
    
    cap server_production setup:server
    
    then
    
    cap setup:site
    
    done
    
    