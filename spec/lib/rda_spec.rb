require 'spec_helper'

describe Rda do
  describe '.config' do
    let(:dummy_path) { File.join(File.dirname(__FILE__), '../dummy') }

    before do
      Rda::Rails.should_receive(:root).any_number_of_times.and_return(dummy_path)
    end

    subject { Rda.config }

    it { should be_a(Confstruct::Configuration) }

    its(:domain) { should == 'dummy.local' }
    its(:rails_env) { should == 'development' }
    specify { subject.nginx.conf_dir.should == '/opt/nginx/conf' }
    specify { subject.passenger.user.should == 'root' }
    specify { subject.passenger.group.should == 'root' }
  end

  describe '.configure' do
    it 'sets the config paths of nginx' do
      Rda.configure do
        rails_env 'production'
      end

      Rda.config.rails_env.should == 'production'
    end
  end
end
