module Rda
  module Rails
    def self.app_name
      ::Rails.application.class.to_s.split('::').first.underscore.dasherize
    end
  end
end
