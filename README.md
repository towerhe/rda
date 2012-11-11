## Rda

### Description

Rda(Rails Development Assist) is combined with lots of useful commands which can help you to setup your development enviroments and tools more quickly.

### Features

* Set up RVM for your rails application
* Deploy your rails application to Nginx (rails_env is set to development by default)
* Release your rails application

### Usage

#### Installation

```bash
gem install rda
```

Or simply add rda to the Gemfile

```ruby
gem 'rda'
```

And then, you should run `rda init` under the root of your application.

#### Configuration

After you run `rda init` successfully. You will see a generated file
named `.rda` under the root of your application and it contains options
like:
[rda.json](https://github.com/towerhe/rda/blob/develop/lib/rda/templates/rda.json)

#### Set up RVM

```bash
rda rvm setup
```

First of all, this command will check whether the RVM is installed. If RVM is installed, it will create a .rvmrc for the application with the content which looks like:

```bash
if [[ -s '/path/to/rvm/environments/ruby-1.9.3-p286@app_name' ]]; then
  . '/path/to/rvm/environments/ruby-1.9.3-p286@app_name'
else
  rvm use ruby-1.9.3-p286@app_name --create
fi
```

And then, it will create a config file to set up load paths of your
applications.

```ruby
# config/setup_load_paths.rb
if ENV['MY_RUBY_HOME'] && ENV['MY_RUBY_HOME'].include?('rvm')
  begin
    require 'rvm'
    RVM.use_from_path! File.dirname(File.dirname(__FILE__))
  rescue LoadError
    raise "RVM gem is currently unavailable."
  end
end

# If you're not using Bundler at all, remove lines bellow
ENV['BUNDLE_GEMFILE'] = File.expand_path('../Gemfile',
                                         File.dirname(__FILE__))
require 'bundler/setup'
```

After setting up RVM, you need to trust the rvmrc by:

```bash
rvm rvmrc trust
```

Or you can set `rvm_trust_rvmrcs_flag=1` in ~/.rvmrc or /etc/rvmrc.

If RVM is not installed, this command will do nothing but exit.

#### Discard RVM settings

```bash
rda rvm discard
```

This command removes the `.rvmrc` and `config/setup_load_paths.rb` from your rails application.

#### Setup Nginx

```bash
rda nginx setup
```

Please make sure that you have the write permission to config your nginx, or you can run:

```bash
rvmsudo rda nginx setup
```

It will try to create `sites-available` and `sites-enabled` to save the configs of rails applications.

* sites-available saves the configs of the rails applications.
* sites-enabled saves the link to the rails applications.

Next it will set Nginx to include the configs under `sites-enabled`. It means that only the applications configured under `sites-enabled` will be loaded.

#### Deploy application

Now you should deploy your applications with a new command of rda.

```bash
rda app deploy
```

It will create a config file for your application under `sites-available` and create a link to the config file under `sites-enabled`. After all, it will create a local hostname for your application in `/etc/hosts`.

#### Restart application

```bash
rda app restart
```

This command touches `tmp/restart.txt` to restart your rails application, For detail, please visit [http://bit.ly/ztKA07](http://bit.ly/ztKA07)

#### Release your rails application

You should create a `VERSION` under your application root path.

```bash
rda app release
```

### License

This project rocks and uses MIT-LICENSE.
