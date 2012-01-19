module Rda
  class Nginx < Thor
    include Thor::Actions

    DEFAULT_CONF_PATHS = ['/etc/nginx', '/usr/local/nginx/conf', '/opt/nginx/conf']

    def self.source_root
      File.dirname(__FILE__)
    end

    desc "Setup", "Deploy rails application to Nginx"
    def setup
      if available_paths.empty?
        prompt_nginx_not_found

        return
      end

      @conf_dir = available_paths.first
      begin
        @conf_dir = ask_for_choosing_one if available_paths.size > 1
        mkdir_for_sites
      rescue SystemExit
        $stderr.puts "ERROR: You need to choose a config directory of Nginx!"
        return
      end
      
      include_sites_enabled

      append_file "/etc/hosts", "#{hostname}  127.0.0.1"

      template("templates/nginx", "#{@conf_dir}/sites-available/#{hostname}")
      system("ln -s #{@conf_dir}/sites-available/#{hostname} #{@conf_dir}/sites-enabled/#{hostname}")
    end

    private
    def hostname
      "#{Rda::Rails.app_name}.local"
    end

    def available_paths
      search_paths = Rda.config.nginx_conf_paths || []
      search_paths = DEFAULT_CONF_PATHS if search_paths.empty?
      @paths ||= search_paths.select { |p| Dir.exists? p if p } unless search_paths.empty?
    end

    def prompt_nginx_not_found
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
        dir = @conf_dir + "/sites-#{n}"
        FileUtils.mkdir_p(dir) unless Dir.exists?(dir)
      end
    end

    def include_sites_enabled
      conf = @conf_dir + '/nginx.conf'
      gsub_file conf, /http {/, <<-INCLUDE_SITES_ENABLED
http {
  include #{@conf_dir}/sites-enabled/*;
      INCLUDE_SITES_ENABLED
    end
  end
end
