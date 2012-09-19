namespace :rda do
  namespace :rvm do
    rvm = Rda::Rvm.new

    desc "Set up RVM for your rails application"
    task :setup do
      rvm.setup
    end

    desc "Discard RVM settings of your rails application"
    task :discard do
      rvm.discard
    end
  end

  namespace :nginx do
    nginx = Rda::Nginx.new

    desc "Set up Nginx for your rails application"
    task :setup => :environment do
      nginx.setup
    end

    desc "Discard Nginx settings of your rails application"
    task :discard => :environment do
      nginx.discard
    end
  end

  namespace :app do
    app = Rda::App.new

    desc "Restart your rails application"
    task :restart do
      app.restart
    end
  end
end
