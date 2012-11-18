module Rda
  class Nginx < Thor
    include Thor::Actions
    include Helper

    desc "setup", "Set up your rails application"
    def setup(options = {})
      return unless installed?

      mkdir_for_sites
      include_sites_enabled
    end

    def self.setup?
      conf_dir = Rda.config.nginx.conf_dir

      File.directory?(File.join(conf_dir, 'sites-available')) &&
        File.directory?(File.join(conf_dir, 'sites-enabled'))
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

    def mkdir_for_sites
      %W(available enabled).each do |n|
        dir = conf_dir + "/sites-#{n}"
        empty_directory(dir) unless File.directory?(dir)
      end
    end

    def include_sites_enabled
      unless configured?(conf_path, "include #{conf_dir}/sites-enabled/*;")
        gsub_file conf_path, /http \{/, <<-INCLUDE_SITES_ENABLED
http {
    include #{conf_dir}/sites-enabled/*;
        INCLUDE_SITES_ENABLED
      end
    end
  end
end
