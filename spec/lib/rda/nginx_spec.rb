require 'spec_helper'

describe Rda::Nginx do
  subject { Rda::Nginx.new }

  let(:conf_dir) { File.join(File.dirname(__FILE__), '../../tmp') }

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
end
