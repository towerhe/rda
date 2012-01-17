module Rda
  class Rvm < Thor
    include Thor::Actions

    def self.source_root
      File.dirname(__FILE__)
    end

    desc "setup", "Setup RVM for rails application"
    def setup
      if installed?
        template('templates/rvmrc', rvmrc_path)
      else
        puts "RVM is not found. Please make sure that RVM is installed."
      end
    end

    desc "discard", "Discard RVM settings for rails application"
    def discard
      if File.exists?(rvmrc_path)
        remove_file(rvmrc_path)
      else
        puts "#{rvmrc_path} not found."
      end
    end

    private
    def installed?
      rvm_path && Dir.exists?(rvm_path)
    end

    def rvm_path
      ENV['rvm_path']
    end

    def gemset_name
      "ruby-#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}@#{Rda::Rails.app_name}"
    end

    def gemset_env
      "#{rvm_path}/environments/#{gemset_name}"
    end

    def rvmrc_path
      "#{::Rails.root}/.rvmrc"
    end
  end
end
