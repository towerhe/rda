require 'thor'
require 'multi_json'
require 'confstruct'
require 'confstruct/configuration'
require 'active_support/inflector'

require 'rda/helper'
require 'rda/command'

module Rda
  class << self
    def config
      begin
        @config ||= Confstruct::Configuration.new(
          MultiJson.load(File.open(File.join(Rda::Rails.root, '.rda')))
        )
      rescue Errno::ENOENT
        $stderr.puts 'ERROR: Rda is not initialized, please run `rda init` first.'
      end
    end

    def configure(&block)
      config.configure(&block)
    end
  end
end
