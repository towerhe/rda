require 'spec_helper'

describe Rda::Helper do
  class MyClass
    include Rda::Helper
  end

  let(:obj) { MyClass.new }
  let(:file) { File.join(File.dirname(__FILE__), '../../fixtures/nginx.conf') }

  describe '#configured?' do
    it 'returns true if the specified option is configured' do
      obj.should be_configured file, "passenger_default_user root;"
    end
  end
end
