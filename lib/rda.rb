require 'rails'
require 'thor'
require 'confstruct'

require 'rda/railtie'
require 'rda/rails'
require 'rda/rvm'
require 'rda/nginx'
require 'rda/app'

module Rda
  @@config = Confstruct::Configuration.new do
    nginx_conf_paths ['/etc/nginx', '/usr/local/nginx/conf', '/opt/nginx/conf']
  end

  def self.config
    @@config
  end

  def self.configure(&block)
    @@config.configure(&block)
  end
end
