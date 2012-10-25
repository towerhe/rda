require 'thor'
require 'confstruct'
require 'confstruct/configuration'
require 'active_support/inflector'

require 'rda/rails'
require 'rda/rvm'
require 'rda/nginx'
require 'rda/app'

module Rda
  class << self
    def config
      @config ||= Confstruct::Configuration.new do
        nginx_conf_paths ['/etc/nginx', '/usr/local/nginx/conf', '/opt/nginx/conf']
      end
    end

    def configure(&block)
      config.configure(&block)
    end
  end
end
