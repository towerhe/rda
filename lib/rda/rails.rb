module Rda
  module Rails
    def self.app_name
      @app_name ||= begin
                      IO.foreach(File.join(Dir.pwd, 'config.ru')) do |l|
                        if l =~ /run\s+(.*)::Application/
                          return $1.underscore.dasherize
                        end
                      end
                    rescue
                    end

      unless @app_name
        $stderr.puts "ERROR: You should run rda under rails applications"
        exit
      end
    end

    def self.root
      Dir.pwd if app_name
    end
  end
end
