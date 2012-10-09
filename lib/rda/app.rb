module Rda
  class App < Thor
    desc 'Restart', 'Restart the application'
    def restart
      FileUtils.touch dir_of('tmp') + '/restart.txt'
    end

    desc 'Release', 'Release the application'
    def release
      version_file = File.join(::Rails.root, 'VERSION')
      version = File.exist?(version_file) ? File.read(version_file).strip : ""

      app_name = Rda::Rails.app_name

      pkg_dir = dir_of('pkg')
      tmp_dir = dir_of("pkg/#{app_name}")

      system("rm -fr #{tmp_dir}")
      system("git clone #{::Rails.root} #{tmp_dir}")

      puts "Create the src release..."
      system("rm -fr #{tmp_dir}/.git")
      system("rm -fr #{tmp_dir}/.gitignore")
      system("cd #{pkg_dir};tar czf #{app_name}-#{version}.src.tar.gz #{app_name}")

      puts "Create the bin release..."
      system("bundle package")
      system("mv #{::Rails.root}/vendor/cache #{tmp_dir}/vendor")
      system("cd #{pkg_dir};tar czf #{app_name}-#{version}.bin.tar.gz #{app_name}")
      system("rm -fr #{tmp_dir}")
      puts "#{app_name} #{version} released!"
    end

    private
    def dir_of(dir)
      dir = File.join(::Rails.root.to_s, dir)
      FileUtils.mkdir_p dir unless Dir.exists?(dir)

      dir
    end
  end
end
