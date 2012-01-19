require 'spec_helper'

describe Rda do
  describe '.config' do
    subject { Rda.config }

    it { should be_a(Confstruct::Configuration) }
  end

  describe '.configure' do
    it 'sets the config paths of nginx' do
      Rda.configure do
        nginx_conf_paths ['/tmp/rda/nginx/conf']
      end

      Rda.config.nginx_conf_paths.should have(1).item
      Rda.config.nginx_conf_paths.should include('/tmp/rda/nginx/conf')
    end
  end
end
