source 'http://ruby.taobao.org'

# Declare your gem's dependencies in rda.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# jquery-rails is used by the dummy application
gem 'jquery-rails'

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  gem 'pry'
  gem 'rspec'
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'fivemat'
  if RUBY_PLATFORM =~ /darwin/
    gem 'ruby_gntp'
  elsif RUBY_PLATFORM =~ /linux/
    gem 'libnotify'
  end
end
