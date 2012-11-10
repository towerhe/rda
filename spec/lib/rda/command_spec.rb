require 'spec_helper'

describe Rda::Command do
  subject { Rda::Command.new }

  describe '#init' do
    let(:tmp_path) { File.join(File.dirname(__FILE__), '../../tmp') }

    before do
      Rda::Rails.should_receive(:root).any_number_of_times.and_return(tmp_path)
    end

    after { `rm -f #{Rda::Rails.root}/.rda` }

    it 'creates a file named .rda' do
      subject.init

      File.should be_exists("#{Rda::Rails.root}/.rda")
    end
  end
end
