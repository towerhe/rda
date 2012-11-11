require 'spec_helper'

describe Rda::App do
  subject { Rda::App.new }

  let(:app_dir) { File.join(File.dirname(__FILE__), '../../dummy') }
  let(:nginx_conf_dir) { File.join(File.dirname(__FILE__), '../../tmp') }

  before { Rda::Rails.should_receive(:root).any_number_of_times.and_return(app_dir) }

  describe '#deploy' do
    before do
      Rda.stub_chain(:config, :domain).and_return('dummy.local')
      Rda.stub_chain(:config, :rails_env).and_return('development')
      Rda.stub_chain(:config, :nginx, :conf_dir).and_return(nginx_conf_dir)
      Rda.stub_chain(:config, :passenger).and_return(:user => 'root', :group => 'root')
    end

    context 'when nginx is not set up' do
      it 'prompts that nginx is not set up' do
        capture(:stderr) do
          subject.deploy
        end.should == <<-PROMPT
ERROR: Nginx is not set up properly. Please run `rda nginx setup` first.
        PROMPT
      end
    end

    context 'when nginx is set up properly' do
      before do
        `mkdir -p #{nginx_conf_dir}/sites-available`
        `mkdir -p #{nginx_conf_dir}/sites-enabled`

        subject.should_receive(:append_file).with('/etc/hosts', "127.0.0.1  dummy.local\n").any_number_of_times

        subject.deploy
      end

      after do
        `rm -fr #{nginx_conf_dir}/sites-available`
        `rm -fr #{nginx_conf_dir}/sites-enabled`
      end

      it 'creates a virtual host config file in nginx' do
        File.should be_exists(File.join(nginx_conf_dir, 'sites-available/dummy.local'))
      end

      it 'enables the created virtual host' do
        File.should be_exists(File.join(nginx_conf_dir, 'sites-enabled/dummy.local'))
      end
    end
  end

  describe '#restart' do
    it 'touches restart.txt' do
      FileUtils.should_receive(:touch).with(Rda::Rails.root.to_s + "/tmp/restart.txt")

      subject.restart
    end
  end
end
