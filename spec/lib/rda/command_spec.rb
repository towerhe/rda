require 'spec_helper'

describe Rda::Command do
  subject { Rda::Command.new }

  before(:all) { Dir.chdir(File.join(File.dirname(__FILE__), '../../dummy')) }

  describe '#init' do
    after { `rm -f #{Rda::Rails.root}/.rda` }

    it 'creates a file named .rda' do
      subject.init

      File.should be_exists("#{Rda::Rails.root}/.rda")
    end
  end
end
