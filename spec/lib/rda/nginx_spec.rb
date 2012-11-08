require 'spec_helper'

describe Rda::Nginx do
  subject { Rda::Nginx.new }

  before do
    Rda.configure { nginx_conf_paths ['/etc/nginx', '/usr/local/nginx/conf', '/opt/nginx/conf'] }

    Dir.chdir(File.join(File.dirname(__FILE__), '../../dummy'))
  end

  describe '#setup' do
    context 'when nginx is not found' do
      before do
        File.should_receive(:directory?).with('/etc/nginx').and_return(false)
        File.should_receive(:directory?).with('/usr/local/nginx/conf').and_return(false)
        File.should_receive(:directory?).with('/opt/nginx/conf').and_return(false)
      end

      it 'prompts nginx is not found' do
        capture(:stderr) do
          subject.setup
        end.should == <<-PROMPT
ERROR: Config directory of Nginx is not found in the following paths:

* /etc/nginx
* /usr/local/nginx/conf
* /opt/nginx/conf

        PROMPT
      end
    end

    context 'when found more than one config directory of nginx' do
      before do
        File.should_receive(:directory?).with('/etc/nginx').and_return(true)
        File.should_receive(:directory?).with('/usr/local/nginx/conf').and_return(true)
        File.should_receive(:directory?).with('/opt/nginx/conf').and_return(false)
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
  end

  describe '#discard' do
    let(:dummy_path) { File.dirname(__FILE__) + "/../../tmp/nginx" }

    before do
      FileUtils.mkdir_p dummy_path unless File.directory?(dummy_path)
      FileUtils.copy_file(File.dirname(__FILE__) + "/../../fixtures/nginx.conf", dummy_path + '/nginx.conf')
      Rda.configure { nginx_conf_paths [File.dirname(__FILE__) + "/../../tmp/nginx"] }
    end

    after do
      conf = Rda.config.nginx_conf_paths.first
      FileUtils.rm_r conf if File.directory?(conf)

      Rda.configure { nginx_conf_paths ['/etc/nginx', '/usr/local/nginx/conf', '/opt/nginx/conf'] }
    end

    it 'discards the settings' do
      subject.should_receive(:gsub_file).with("/etc/hosts", "127.0.0.1  dummy.local", '')
      %W(enabled available).each do |n|
        subject.should_receive(:remove_file).with("#{dummy_path}/sites-#{n}/dummy.local")
      end
      subject.should_receive(:remove_file).with("#{Rda::Rails.root}/config/setup_load_paths.rb")

      subject.discard
    end
  end
end
