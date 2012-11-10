module Rda
  class Nginx < Thor
    include Thor::Actions

    def self.source_root
      File.dirname(__FILE__)
    end

    desc "setup", "Set up your rails application"
    def setup(options = {})
      return unless installed?

      @hostname, @environment = options["hostname"], options["environment"]

      create_setup_load_paths
      mkdir_for_sites
      set_passenger_user_and_group
      include_sites_enabled

      template("templates/nginx", "#{conf_dir}/sites-available/#{hostname}")
      link_file("#{conf_dir}/sites-available/#{hostname}", "#{conf_dir}/sites-enabled/#{hostname}")

      unless configured?('/etc/hosts', "127.0.0.1  #{hostname}")
        append_file "/etc/hosts", "127.0.0.1  #{hostname}"
      end
    end

    desc "discard", "Remove the settings of your rails application from nginx"
    def discard(options = {})
      return unless installed?

      @hostname = options["hostname"]

      %W(enabled available).each do |n|
        remove_file "#{conf_dir}/sites-#{n}/#{hostname}"
      end

      gsub_file("/etc/hosts", "127.0.0.1  #{hostname}", '')
      remove_file "#{Rda::Rails.root}/config/setup_load_paths.rb"
    end

    private
    def installed?
      File.exists?(conf_path) if conf_path
    end

    def conf_dir
      Rda.config.nginx.conf_dir
    end

    def conf_path
      if File.exists? File.join(conf_dir, 'nginx.conf')
        return File.join(conf_dir, 'nginx.conf')
      end

      $stderr.puts "ERROR: Missing `nginx.conf` in `#{conf_dir}`."
    end

    def hostname
      @hostname || "#{Rda::Rails.app_name}.local"
    end

    def create_setup_load_paths
      copy_file "templates/setup_load_paths.rb", "#{Rda::Rails.root}/config/setup_load_paths.rb"
    end

    def mkdir_for_sites
      %W(available enabled).each do |n|
        dir = conf_dir + "/sites-#{n}"
        empty_directory(dir) unless File.directory?(dir)
      end
    end

    def set_passenger_user_and_group
      conf = conf_dir + '/nginx.conf'

      unless configured?(conf, 'passenger_default_user')
        gsub_file conf, /http \{/, <<-PASSENGER
http {
    passenger_default_user root;
        PASSENGER
      end

      unless configured?(conf, 'passenger_default_group')
        gsub_file conf, /http \{/, <<-PASSENGER
http {
    passenger_default_group root;
        PASSENGER
      end
    end

    def include_sites_enabled
      unless configured?(conf_path, "include #{conf_dir}/sites-enabled/*;")
        gsub_file conf, /http \{/, <<-INCLUDE_SITES_ENABLED
http {
    include #{conf_dir}/sites-enabled/*;
        INCLUDE_SITES_ENABLED
      end
    end

    def configured?(fname, conf)
      File.open(fname) do |f|
        f.readlines.each do |l|
          if l.strip.start_with?(conf)
            $stderr.puts "INFO: #{conf} has already been set!"

            return true
          end
        end
      end

      false
    end
  end
end
