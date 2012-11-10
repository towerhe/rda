%w(rails rvm nginx app).each do |f|
  require File.join(File.dirname(__FILE__), f)
end

module Rda
  class Command < Thor
    include Thor::Actions

    def self.source_root
      File.dirname(__FILE__)
    end

    desc 'init', 'Create a default config for rda.'
    def init
      template('templates/rda.json', "#{Rda::Rails.root}/.rda")
    end

    desc 'rvm ACTION', 'Set up RVM. Available actions: setup, discard.'
    def rvm(action)
      Rda::Rvm.new.send(action.to_sym)
    end

    desc 'nginx ACTION', 'Manage settings of nginx. Available actions: setup, discard.'
    method_option :environment, aliases: "-e", desc: "Set the environment of the application"
    method_option :hostname, aliases: "-h", desc: "Set the hostname of the application"
    def nginx(action)
      Rda::Nginx.new.send(action.to_sym, options)
    end

    desc 'app ACTION', 'Manage the lifecycle of the application. Available actions: restart, release.'
    def app(action)
      Rda::App.new.send(action.to_sym)
    end

    private
    def app_name
      Rails.app_name
    end
  end
end
