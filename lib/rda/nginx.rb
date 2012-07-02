module Rda
  class Nginx < Thor
    include Thor::Actions

    DEFAULT_CONF_PATHS = ['/etc/nginx', '/usr/local/nginx/conf', '/opt/nginx/conf']

    def self.source_root
      File.dirname(__FILE__)
    end

    desc "Setup", "Deploy rails application to Nginx"
    def setup
      return unless installed?

      create_setup_load_paths
      mkdir_for_sites
      set_passenger_user_and_group
      include_sites_enabled

      template("templates/nginx", "#{conf_path}/sites-available/#{hostname}")
      link_file("#{conf_path}/sites-available/#{hostname}", "#{conf_path}/sites-enabled/#{hostname}")

      unless configured?('/etc/hosts', "127.0.0.1  #{hostname}")
        append_file "/etc/hosts", "127.0.0.1  #{hostname}"
      end
    end

    desc "Discard", "Remove the Nginx setting of rails application"
    def discard
      return unless installed?

      %W(enabled available).each do |n|
        remove_file "#{conf_path}/sites-#{n}/#{hostname}"
      end

      gsub_file("/etc/hosts", "127.0.0.1  #{hostname}", '')
      remove_file "#{::Rails.root}/config/setup_load_paths.rb"
    end

    private
    def installed?
      Dir.exists?(conf_path) if conf_path
    end

    def conf_path
      return @conf_path if @conf_path

      if available_paths.empty?
        prompt_not_found

        return
      end

      @conf_path = available_paths.first
      begin
        @conf_path = ask_for_choosing_one if available_paths.size > 1
      rescue SystemExit
        $stderr.puts "ERROR: You need to choose a config directory of Nginx!"
        return
      end

      @conf_path
    end

    def hostname
      "#{Rda::Rails.app_name}.local"
    end

    def available_paths
      search_paths = Rda.config.nginx_conf_paths || []
      search_paths = DEFAULT_CONF_PATHS if search_paths.empty?
      @paths ||= search_paths.select { |p| Dir.exists? p if p } unless search_paths.empty?
    end

    def prompt_not_found
      $stderr.puts "ERROR: Config directory of Nginx is not found in the following paths:\n\n"
      Rda.config.nginx_conf_paths.each { |p| $stderr.puts "* #{p}" }
      $stderr.puts "\n"
    end

    def ask_for_choosing_one
      available_paths.each_with_index { |p, i| puts "#{i + 1}) #{p}" }
      puts "\n"
      chosen = ask "Found more than one config directory of Nginx, please choose one to setup:"

      index = chosen.to_i - 1

      index >= 0 && index < available_paths.size ? available_paths[index] : exit
    end

    def create_setup_load_paths
      copy_file "templates/setup_load_paths.rb", "#{::Rails.root}/config/setup_load_paths.rb"
    end

    def mkdir_for_sites
      %W(available enabled).each do |n|
        dir = conf_path + "/sites-#{n}"
        empty_directory(dir) unless Dir.exists?(dir)
      end
    end

    def set_passenger_user_and_group
      conf = conf_path + '/nginx.conf'

      unless configured?(conf, 'passenger_default_user')
        gsub_file conf, /http {/, <<-PASSENGER
http {
    passenger_default_user root;
        PASSENGER
      end

      unless configured?(conf, 'passenger_default_group')
        gsub_file conf, /http {/, <<-PASSENGER
http {
    passenger_default_group root;
        PASSENGER
      end
    end

    def include_sites_enabled
      conf = conf_path + '/nginx.conf'
      unless configured?(conf, "include #{conf_path}/sites-enabled/*;")
        gsub_file conf, /http {/, <<-INCLUDE_SITES_ENABLED
http {
    include #{conf_path}/sites-enabled/*;
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
