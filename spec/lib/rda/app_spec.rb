require 'spec_helper'

describe Rda::App do
  subject { Rda::App.new }

  before(:all) { Dir.chdir(File.join(File.dirname(__FILE__), '../../dummy')) }

  describe '#restart' do
    it 'touches restart.txt' do
      FileUtils.should_receive(:touch).with(Rda::Rails.root.to_s + "/tmp/restart.txt")

      subject.restart
    end
  end
end
