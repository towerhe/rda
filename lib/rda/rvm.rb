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
        create_setup_load_paths
      else
        $stderr.puts "ERROR: RVM is not found. Please make sure that RVM is installed."
      end
    end

    desc "discard", "Discard RVM settings for rails application"
    def discard
      remove_file(rvmrc_path)
      remove_file(setup_load_paths_path)
    end

    private
    def installed?
      rvm_path && File.directory?(rvm_path)
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
      "#{Rda::Rails.root}/.rvmrc"
    end

    def setup_load_paths_path
      "#{Rda::Rails.root}/config/setup_load_paths.rb"
    end

    def create_setup_load_paths
      copy_file "templates/setup_load_paths.rb", "#{Rda::Rails.root}/config/setup_load_paths.rb"
    end

    def remove_file(file)
      if File.exists?(file)
        super(file)
      else
        $stderr.puts "ERROR: #{file} not found."
      end
    end
  end
end
