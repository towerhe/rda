## Rda

### Description

Rda(Rails Development Assist) is combined with lots of useful commands which can help you to setup your development enviroments and tools more quickly.

### Features

* Set up RVM for your rails application
* Deploy your rails application to Nginx (rails_env is set to development by default)
* Release your rails application (not yet)

### Usage

#### Installation

```bash
gem install rda
```

Or simply add rda to the Gemfile

```ruby
gem 'rda'
```

That's all.

#### Configuration

For configuring rda, you need to create an initializer for rda:

```ruby
# config/initializers/rda.rb
if Rails.env == 'development'
  Rda.configure do
    nginx_conf_paths ['/etc/nginx', '/opt/nginx/conf', '/usr/local/nginx/conf']
  end
end
```

#### Set up RVM

```bash
rda rvm setup
```

First of all, this command will check whether the RVM is installed. If RVM is installed, it will create a .rvmrc for the application with the content which looks like:

```bash
if [[ -s '/path/to/rvm/environments/ruby-1.9.3-p194@app_name' ]]; then
  . '/path/to/rvm/environments/ruby-1.9.3-p194@app_name'
else
  rvm use ruby-1.9.3-p194@app_name --create
fi
```

After setting up RVM, you need to trust the rvmrc by:

```bash
rvm rvmrc trust
```

Or you can set `rvm_trust_rvmrcs_flag=1` in ~/.rvmrc or /etc/rvmrc.

If RVM is not installed, this command will do nothing but exit.

#### Discard RVM settings

```bash
rda rvm:discard
```

This command removes the .rvmrc from your rails application.

#### Setup Nginx

```bash
rda nginx setup --environment production --hostname www.example.com
```

First this command will try to find the config files of Nginx, which you have installed, from the following paths:

* /etc/nginx
* /usr/local/nginx/conf
* /opt/nginx/conf

You can change the default searching paths by:

```ruby
Rda.configure { nginx_conf_paths ['/path/to/nginx/conf'] }
```

Please make sure that you have the write permission of the directory you choosed, or you can run:

```bash
rvmsudo rda nginx setup --environment production --hostname www.example.com
```

If there are more than one paths found, it will give you a choice to decide which one will be used. After choosing a proper path, it will try to create two directories sites-available and sites-enabled to save the configs of rails applications.

* sites-available saves the configs of the rails applications.
* sites-enabled saves the link to the rails applications.

Next it will set Nginx to include the configs under sites-enabled. It means that only the applications under sites-enabled will be loaded. And than it will create a config file for your application under sites-available and create a link to the config file under sites-enabled. After all, it will create a local hostname for your application in /etc/hosts.


Finally, You need to start Nginx `/path/to/nginx/sbin/nginx` and then visit http://your_app_name.local.

#### Discard Nginx settings

```bash
rda nginx discard --hostname www.example.com # Or

sudo rda nginx discard --hostname www.example.com # Or

rvmsudo rda nginx discard --hostname www.example.com # Using RVM
```

This command will clean up all the things created or configured by rda:nginx:setup.

#### Restart application

```bash
rda app restart
```

This command touches tmp/restart.txt to restart your rails application, For detail, please visit [http://bit.ly/ztKA07](http://bit.ly/ztKA07)

#### Release your rails application(not yet)

```bash
rda app release
```

### License

This project rocks and uses MIT-LICENSE.
