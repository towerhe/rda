require 'spec_helper'

describe Rda::Nginx do
  subject { Rda::Nginx.new }

  before do
    Rda.configure { nginx_conf_paths Rda::Nginx::DEFAULT_CONF_PATHS }
  end

  describe '#setup' do
    context 'when nginx is not found' do
      before do
        Dir.should_receive(:exists?).with('/etc/nginx').and_return(false)
        Dir.should_receive(:exists?).with('/usr/local/nginx/conf').and_return(false)
        Dir.should_receive(:exists?).with('/opt/nginx/conf').and_return(false)
      end

      it 'prompts nginx is not found' do
        capture(:stderr) do
          subject.setup
        end.should == <<-PROMPT
Config directory of Nginx is not found in the following paths:

* /etc/nginx
* /usr/local/nginx/conf
* /opt/nginx/conf

        PROMPT
      end
    end

    context 'when found more than one config directory of nginx' do
      before do
        Dir.should_receive(:exists?).with('/etc/nginx').and_return(true)
        Dir.should_receive(:exists?).with('/usr/local/nginx/conf').and_return(true)
        Dir.should_receive(:exists?).with('/opt/nginx/conf').and_return(false)
      end

      it 'asks to choose one path' do
        choice = <<-CHOICE
1) /etc/nginx
2) /usr/local/nginx/conf

Found more than one config directory of Nginx, please choose one to setup:
        CHOICE

        $stdin.should_receive(:gets).and_return('\n')

        capture(:stdout) do
          subject.setup
        end.strip.should == choice.strip
      end
    end

    context 'when only one config directory of nginx found' do
      let(:dummy_path) { File.dirname(__FILE__) + "/../../tmp/nginx" }

      before do
        FileUtils.mkdir_p dummy_path unless Dir.exists?(dummy_path)
        FileUtils.copy_file(File.dirname(__FILE__) + "/../../fixtures/nginx.conf", dummy_path + '/nginx.conf')
        Rda.configure { nginx_conf_paths [File.dirname(__FILE__) + "/../../tmp/nginx"] }
      end

      after do
        FileUtils.rm_r dummy_path if Dir.exists?(dummy_path)
        Rda.configure { nginx_conf_paths Rda::Nginx::DEFAULT_CONF_PATHS }
      end

      it 'sets Nginx properly' do
        # loads RVM
        subject.should_receive(:copy_file).with("templates/setup_load_paths.rb", "#{::Rails.root}/config/setup_load_paths.rb")

        # creates sites-available and sites-enabled
        %W(available enabled).each do |n|
          path = "#{dummy_path}/sites-#{n}"
          subject.should_receive(:empty_directory).with(path)
        end

        # sets default passenger user and group
        subject.should_receive(:gsub_file).with("#{dummy_path}/nginx.conf", /http {/, <<-PASSENGER
http {
    passenger_default_user root;
    passenger_default_group root;
          PASSENGER
        )

        # sets Nginx to include sites-enabled
        subject.should_receive(:gsub_file).with("#{dummy_path}/nginx.conf", /http {/, <<-INCLUSION
http {
    include #{dummy_path}/sites-enabled/*;
          INCLUSION
        )

        # creates a nginx config file for the rails application under
        # sites-available
        subject.should_receive(:template).with('templates/nginx', "#{dummy_path}/sites-available/dummy.local")

        # creates a symbol link to the nginx config file of the rails
        # application
        subject.should_receive(:link_file).with("#{dummy_path}/sites-available/dummy.local", "#{dummy_path}/sites-enabled/dummy.local")

        # creates a local hostname for the rails application
        subject.should_receive(:append_file).with("/etc/hosts", "127.0.0.1  dummy.local")

        subject.setup
      end
    end
  end

  describe '#discard' do
    let(:dummy_path) { File.dirname(__FILE__) + "/../../tmp/nginx" }

    before do
      FileUtils.mkdir_p dummy_path unless Dir.exists?(dummy_path)
      FileUtils.copy_file(File.dirname(__FILE__) + "/../../fixtures/nginx.conf", dummy_path + '/nginx.conf')
      Rda.configure { nginx_conf_paths [File.dirname(__FILE__) + "/../../tmp/nginx"] }
    end

    after do
      conf = Rda.config.nginx_conf_paths.first
      FileUtils.rm_r conf if Dir.exists?(conf)

      Rda.configure { nginx_conf_paths [Rda::Nginx::DEFAULT_CONF_PATHS] }
    end

    it 'discards the settings' do
      subject.should_receive(:gsub_file).with("/etc/hosts", "127.0.0.1  dummy.local", '')
      %W(enabled available).each do |n|
        subject.should_receive(:remove_file).with("#{dummy_path}/sites-#{n}/dummy.local")
      end
      subject.should_receive(:remove_file).with("#{::Rails.root}/config/setup_load_paths.rb")

      subject.discard
    end
  end
end
