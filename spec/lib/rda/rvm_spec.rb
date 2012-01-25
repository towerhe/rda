require 'spec_helper'

describe Rda::Rvm do
  subject { Rda::Rvm.new }

  describe '#setup' do
    context 'when RVM is installed' do
      before(:all) do
        @rvm_path = ENV['rvm_path']
        ENV['rvm_path'] ||= '/tmp'

        subject.setup
      end

      after(:all) do
        `rm -f #{Rails.root}/.rvmrc`

        ENV['rvm_path'] = @rvm_path
      end

      it 'creates a file named .rvmrc' do
        File.should be_exists("#{Rails.root}/.rvmrc")
      end

      describe 'checking the contents of .rvmrc' do
        before { @contents = File.read("#{Rails.root}/.rvmrc") }

        it "configs RVM properly" do
          contents = <<-RVMRC
if [[ -s "#{ENV['rvm_path']}/environments/ruby-#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}@dummy" ]]; then
  . "#{ENV['rvm_path']}/environments/ruby-#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}@dummy"
else
  rvm --create use "ruby-#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}@dummy"
fi
          RVMRC

          @contents.should == contents
        end
      end
    end
    
    context 'when RVM is not installed' do
      before do
        subject.should_receive(:installed?).and_return(false)

        subject.setup
      end

      it 'does not create .rvmrc' do
        File.should_not be_exists("#{Rails.root}/.rvmrc")
      end
    end

  end
end
