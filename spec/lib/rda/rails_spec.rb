require 'spec_helper'

describe Rda::Rails do
  let(:path) { File.join(File.dirname(__FILE__), '../../dummy') }

  it 'returns the name of the rails app' do
    Dir.chdir(path) do
      Rda::Rails.app_name.should == 'dummy'
    end
  end

  it 'returns the root path of the rails app' do
    Dir.chdir(path) do
      Rda::Rails.root.should == Dir.pwd
    end
  end
end
