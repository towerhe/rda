require 'spec_helper'

describe Rda::App do
  subject { Rda::App.new }

  let(:app_dir) { File.join(File.dirname(__FILE__), '../../dummy') }

  describe '#restart' do
    before { Rda::Rails.should_receive(:root).any_number_of_times.and_return(app_dir) }

    it 'touches restart.txt' do
      FileUtils.should_receive(:touch).with(Rda::Rails.root.to_s + "/tmp/restart.txt")

      subject.restart
    end
  end
end
