namespace :rda do
  namespace :rvm do
    rvm = Rda::Rvm.new

    desc "Setup RVM for rails application"
    task :setup do
      rvm.setup
    end

    desc "Discard RVM settings for rails application"
    task :discard do
      rvm.discard
    end
  end
end
