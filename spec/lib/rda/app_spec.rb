require 'spec_helper'

describe Rda::App do
  subject { Rda::App.new }

  describe '#restart' do
    it 'touches restart.txt' do
      FileUtils.should_receive(:touch).with(::Rails.root.to_s + "/tmp/restart.txt")

      subject.restart
    end
  end
end
