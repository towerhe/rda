require 'spec_helper'

describe Rda::Nginx do
  subject { Rda::Nginx.new }

  let(:conf_dir) { File.join(File.dirname(__FILE__), '../../tmp') }

  before do
  end

  describe '#setup' do
    context 'when the config file of nginx is not found' do
      before do
        File.should_receive(:exists?).with('/opt/nginx/conf/nginx.conf').and_return(false)
      end

      it 'prompts `nginx.conf` is not found' do
        capture(:stderr) do
          subject.setup
        end.should == <<-PROMPT
ERROR: Missing `nginx.conf` in `/opt/nginx/conf`.
        PROMPT
      end
    end
  end

  describe '#discard' do
    let(:conf_dir) { File.dirname(__FILE__) + "/../../tmp/nginx" }

    before do
      FileUtils.mkdir_p conf_dir unless File.directory?(conf_dir)
      FileUtils.copy_file(File.dirname(__FILE__) + "/../../fixtures/nginx.conf", conf_dir + '/nginx.conf')
      Rda.stub_chain(:config, :nginx, :conf_dir).any_number_of_times.and_return(conf_dir)
    end

    after do
      FileUtils.rm_r conf_dir if File.directory?(conf_dir)
    end

    it 'discards the settings' do
      subject.should_receive(:gsub_file).with("/etc/hosts", "127.0.0.1  dummy.local", '')
      %W(enabled available).each do |n|
        subject.should_receive(:remove_file).with("#{conf_dir}/sites-#{n}/dummy.local")
      end
      subject.should_receive(:remove_file).with("#{Rda::Rails.root}/config/setup_load_paths.rb")

      subject.discard
    end
  end
end
