require 'spec_helper'

describe Rda::Rvm do
  subject { Rda::Rvm.new }

  before(:all) { Dir.chdir(File.join(File.dirname(__FILE__), '../../dummy')) }

  describe '#setup' do
    context 'when RVM is installed' do
      before(:all) do

        @rvm_path = ENV['rvm_path']
        ENV['rvm_path'] ||= '/tmp'

        subject.setup
      end

      after(:all) do
        `rm -f #{Rda::Rails.root}/.rvmrc`
        `rm -f #{Rda::Rails.root}/config/setup_load_paths.rb`

        ENV['rvm_path'] = @rvm_path
      end

      it 'creates a file named .rvmrc' do
        File.should be_exists("#{Rda::Rails.root}/.rvmrc")
      end

      it 'sets up loading paths' do
        File.should be_exists("#{Rda::Rails.root}/config/setup_load_paths.rb")
      end

      describe 'checking the contents of .rvmrc' do
        before { @contents = File.read("#{Rda::Rails.root}/.rvmrc") }

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
        File.should_not be_exists("#{Rda::Rails.root}/.rvmrc")
      end

      it 'does not create `setup_load_paths`' do
        File.should_not be_exists("#{Rda::Rails.root}/config/setup_load_paths.rb")
      end
    end
  end
end
