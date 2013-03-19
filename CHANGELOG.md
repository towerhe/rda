**0.4.1 (Tue, Mar 19, 2013)

* Compatible with JRuby

**0.4.0 (2012)**

* Provide support to configure options of rda
* Set up load paths of applications when setting up rvm
* Introduce a new command `rda app deploy` to deploy applications to
  nginx

**0.3.3 (Fri, Nov 9, 2012)**

* Added a rake task for running specs
* Removed rake tasks of rdoc
* Fixed the description

**0.3.2 (Thu, Nov 8, 2012)**

* Ruby 1.8.7 compatible

**0.3.1 (Tue, Nov 8, 2012)**

* Do not run as a rails plugin, it is a plain gem.

**0.3.0 (Tue, Oct 9, 2012)**

* Removed the rake tasks
* Provide support to release the application

**0.2.0 (Tue, Oct 9, 2012)**

* Support to specify the environment of the application
* Support to specify the hostname of the application

**0.0.6 (Mon, Jul 2, 2012)**

* Fixed gemspec error

**0.0.5 (Mon, Jul 2, 2012)**

* Updated the dependencies
* Check whether passenger_default_user is set
* Check whether passenger_default_group is set
* Check whether sites-enabled is included
* Check whether the hostname is set

**0.0.2 (Wed, Jan 25, 2012)**

* Fixed rvmrc template errors
* Idented sites-enabled inclusion
* Set default passenger user and group
* Added setup_load_paths.rb
