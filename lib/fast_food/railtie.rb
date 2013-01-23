require 'fast_food'
require 'rails'
module FastFood
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/deployment.rake"
    end
  end
end