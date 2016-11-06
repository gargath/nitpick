# Nitpick
A single-page app / REST-backend tech demo

## Overview
Nitpick consists of an AngularJS-based frontend and a REST backend written in Ruby.
The backend is a Rack application serving both the HTML / JS for the UI as well as running the REST server itself.

## Setup Development Environment
In order to successfully deploy Nitpick on Heroku, simply install the Heroku toolbelt and authenticate.
Nitpick has been tested with these Heroku Add-Ons:
* Heroku Postgres
* Heroku Redis
* Papertrail

If you would like to be able to run Nitpick locally, you may follow these steps:

1. Make sure your ruby environment is sane (see [A Note on Windows](#a-note-on-windows))
2. Install Postgresql locally and update `config/database.yml` with the details for environment `dev`
3. Provide a Redis instance for the worker queue. If you are using Windows, check out [vagrant-redis](https://github.com/mdevilliers/vagrant-redis) which in turn requires Vagrant and Virtualbox.
4. Set `REDIS_URL` accordingly.
5. Set `ENV` and `RACK_ENV` both as `dev`
6. `$ bundle install`
7. `$ bundle exec rake db:migrate` (in order to initialize the schema, skip if you already have it)
8. `$ bundle exec foreman start`  
This will launch two processes: the rack application itself and a single Resque worker.

### A Note on Windows

If you are just starting out with Ruby on Windows, there are a couple of things you should do first:

1. Make sure [rubygems is up to date](https://gist.github.com/luislavena/f064211759ee0f806c88).  
If `gem install` or `bundle install` give you  
```SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed```,  
then this is for you. 
2. Install the [DevKit](http://rubyinstaller.org/add-ons/devkit/)
3. Ensure DevKit binaries are in your PATH

Now you should be able to install gems with native extensions.

## Testing
You can run all tests by using `bundle exec rake test`.  
This will run the Karma and Rspec tests as well as Rubocop on the backend code. 
