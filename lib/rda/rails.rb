module Rda
  module Rails
    def self.app_name
      IO.foreach(File.join(Dir.pwd, 'config.ru')) do |l|
        if l =~ /run\s+(.*)::Application/
          return $1.underscore.dasherize
        end
      end
      #::Rails.application.class.to_s.split('::').first.underscore.dasherize
    end

    def self.root
      Dir.pwd if app_name
    end
  end
end
