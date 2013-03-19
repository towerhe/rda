module Rda
  class App < Thor
    include Thor::Actions
    include Helper

    def self.source_root
      File.dirname(__FILE__)
    end

    desc 'deploy', 'Deploy the application to nginx'
    def deploy
      conf_dir = Rda.config.nginx.conf_dir

      unless Rda::Nginx.setup?
        $stderr.puts 'ERROR: Nginx is not set up properly. Please run `rda nginx setup` first.'
        return
      end

      domain = Rda.config.domain

      template("templates/nginx", "#{conf_dir}/sites-available/#{domain}")
      link_file("#{conf_dir}/sites-available/#{domain}", "#{conf_dir}/sites-enabled/#{domain}")

      unless configured?('/etc/hosts', "127.0.0.1  #{domain}")
        append_file "/etc/hosts", "127.0.0.1  #{domain}\n"
      end
    end

    desc 'restart', 'Restart the application'
    def restart
      FileUtils.touch dir_of('tmp') + '/restart.txt'
    end

    desc 'release', 'Release the application'
    def release
      version_file = File.join(Rda::Rails.root, 'VERSION')
      version = File.exist?(version_file) ? File.read(version_file).strip : ""

      app_name = Rda::Rails.app_name

      pkg_dir = dir_of('pkg')
      tmp_dir = dir_of("pkg/#{app_name}")

      system("rm -fr #{tmp_dir}")
      system("git clone #{Rda::Rails.root} #{tmp_dir}")

      puts "Create the src release..."
      system("rm -fr #{tmp_dir}/.git")
      system("rm -fr #{tmp_dir}/.gitignore")
      system("cd #{pkg_dir};tar czf #{app_name}-#{version}.src.tar.gz #{app_name}")

      puts "Create the bin release..."
      system("bundle package --all")
      system("mv #{Rda::Rails.root}/vendor/cache #{tmp_dir}/vendor")
      system("cd #{pkg_dir};tar czf #{app_name}-#{version}.bin.tar.gz #{app_name}")
      system("rm -fr #{tmp_dir}")
      puts "#{app_name} #{version} released!"
    end

    private
    def dir_of(dir)
      dir = File.join(Rda::Rails.root.to_s, dir)
      FileUtils.mkdir_p dir unless File.directory?(dir)

      dir
    end
  end
end
