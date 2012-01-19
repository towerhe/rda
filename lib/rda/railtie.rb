module Rda
  class Railtie < Rails::Railtie
    railtie_name :rda

    rake_tasks do
      load File.dirname(__FILE__) + "/../tasks/rda_tasks.rake"
    end
  end
end
