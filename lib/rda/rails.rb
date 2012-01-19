module Rda
  module Rails
    def self.app_name
      ::Rails.application.class.to_s.split('::').first.downcase
    end
  end
end
