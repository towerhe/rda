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

      mkdir_for_sites
      include_sites_enabled

      template("templates/nginx", "#{conf_path}/sites-available/#{hostname}")
      link_file("#{conf_path}/sites-available/#{hostname}", "#{conf_path}/sites-enabled/#{hostname}")
      
      append_file "/etc/hosts", "#{hostname}  127.0.0.1"
    end

    desc "Discard", "Remove the Nginx setting of rails application"
    def discard
      return unless installed?

      %W(enabled available).each do |n|
        remove_file("#{conf_path}/sites-#{n}/#{hostname}")
      end

      gsub_file("/etc/hosts", "#{hostname}  127.0.0.1", '')
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
      $stderr.puts "Config directory of Nginx is not found in the following paths:\n\n"
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

    def mkdir_for_sites
      %W(available enabled).each do |n|
        dir = conf_path + "/sites-#{n}"
        empty_directory(dir) unless Dir.exists?(dir)
      end
    end

    def include_sites_enabled
      conf = conf_path + '/nginx.conf'
      gsub_file conf, /http {/, <<-INCLUDE_SITES_ENABLED
http {
    include #{conf_path}/sites-enabled/*;
      INCLUDE_SITES_ENABLED
    end
  end
end
