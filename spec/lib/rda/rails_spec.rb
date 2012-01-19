require 'spec_helper'

describe Rda::Rails do
  it 'returns the name of the rails app' do
    Rda::Rails.app_name.should == 'dummy'
  end
end
