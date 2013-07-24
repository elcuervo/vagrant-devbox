This is a slightly modified version of `https://github.com/ejholmes/vagrant-heroku` adapted
to my needs

## Vagrant
Make sure you have the latest Vagrant version installed http://docs.vagrantup.com/v2/installation/

## Easy install
Add the following to your `Vagrantfile`.

```ruby
Vagrant::Config.run do |config|
  config.vm.box = "heroku"
  config.vm.box_url = "https://www.dropbox.com/s/jn3w4kpn644kwwt/heroku.box"
end
```

And run `vagrant up`. The box will be downloaded and imported for you.

### Extra

You can use this Vagrantfile and vm bash script to easily have your env up and
running:

https://gist.github.com/bff38eebbd52008553ef

## Building From Scratch

First, clone the repo and install gems with bundler.

```bash
$ git clone git@github.com:elcuervo/vagrant-heroku.git
$ cd vagrant-heroku
$ bundle install
```

Next, build the box with veewee. Go grab a cup of coffee because this is gonna
take a while.

```bash
$ bundle exec veewee vbox export heroku
$ vagrant box add heroku heroku.box
```

Now all you have to do is setup vagrant in your project.

```bash
$ vagrant init heroku
$ vagrant up
$ vagrant ssh
```

## Included Packages

The packages that are included are carefully selected to closely match those on
the Celadon Cedar stack.

* Ubuntu 10.04 64bit
* Ruby 1.9.3-p392 MRI
* RubyGems 1.8.23
* Python with pip, virtualenv, and virtualenvwrapper
* PostgreSQL 9.2.4
* Redis
* NodeJS 0.10.13
* Foreman https://github.com/ddollar/foreman
