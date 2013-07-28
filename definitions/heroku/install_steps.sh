install_ruby_and_rubygems() {
  msg "Install Ruby from source in /opt so that users of Vagrant can install their own Rubies using packages or however."
  wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p392.tar.bz2
  tar jxf ruby-1.9.3-p392.tar.bz2
  cd ruby-1.9.3-p392
  ./configure --prefix=/opt/ruby
  make
  make install
  cd ..
  rm -rf ruby-1.9.3-p392*
  chown -R root:admin /opt/ruby
  chmod -R g+w /opt/ruby

  msg "Install RubyGems 1.8.23"
  wget http://production.cf.rubygems.org/rubygems/rubygems-1.8.23.tgz
  tar xzf rubygems-1.8.23.tgz
  cd rubygems-1.8.23
  /opt/ruby/bin/ruby setup.rb
  cd ..
  rm -rf rubygems-1.8.23*

  msg "Installing chef & Puppet"
  /opt/ruby/bin/gem install chef --no-ri --no-rdoc
  /opt/ruby/bin/gem install puppet --no-ri --no-rdoc
  /opt/ruby/bin/gem install bundler --no-ri --no-rdoc

  msg "Add the Puppet group so Puppet runs without issue"
  groupadd puppet

  msg "Install Foreman"
  /opt/ruby/bin/gem install foreman --no-ri --no-rdoc

  msg "Add /opt/ruby/bin to the global path as the last resort so Ruby, RubyGems, and Chef/Puppet are visible"
  echo 'PATH=$PATH:/opt/ruby/bin/'> /etc/profile.d/vagrantruby.sh
}

install_python_and_virtualenv() {
  msg "Install pip, virtualenv, and virtualenvwrapper"
  easy_install pip
  pip install virtualenv
  pip install virtualenvwrapper

  msg "Add a basic virtualenvwrapper config to .bashrc"
  echo "export WORKON_HOME=/home/vagrant/.virtualenvs" >> /home/vagrant/.bashrc
  echo "source /usr/local/bin/virtualenvwrapper.sh" >> /home/vagrant/.bashrc
}

install_node_and_npm() {
  msg "Install NodeJs for a JavaScript runtime"
  git clone https://github.com/joyent/node.git
  cd node
  git checkout v0.10.13
  ./configure --prefix=/usr
  make
  make install
  cd ..
  rm -rf node*
}

install_postgres() {
  msg "Install PostgreSQL 9.2.4"
  wget http://ftp.postgresql.org/pub/source/v9.2.4/postgresql-9.2.4.tar.bz2
  tar jxf postgresql-9.2.4.tar.bz2
  cd postgresql-9.2.4
  ./configure --prefix=/usr
  make world
  make install
  cd ..
  rm -rf postgresql-9.2.4*

  msg "Initialize postgres DB"
  useradd -p postgres postgres
  mkdir -p /var/pgsql/data
  chown postgres /var/pgsql/data
  su -c "/usr/bin/initdb -D /var/pgsql/data --locale=en_US.UTF-8 --encoding=UNICODE" postgres
  mkdir /var/pgsql/data/log
  chown postgres /var/pgsql/data/log

  msg "Start postgres"
  su -c '/usr/bin/pg_ctl start -l /var/pgsql/data/log/logfile -D /var/pgsql/data' postgres

  msg "Start postgres at boot"
  sed -i -e 's/exit 0//g' /etc/rc.local
  echo "su -c '/usr/bin/pg_ctl start -l /var/pgsql/data/log/logfile -D /var/pgsql/data' postgres" >> /etc/rc.local

  msg "Add 'vagrant' role"
  su -c 'createuser vagrant -s' postgres
}

install_phantomjs() {
  msg "Install PhantomJS"
  wget https://phantomjs.googlecode.com/files/phantomjs-1.9.1-linux-x86_64.tar.bz2
  tar xfj phantom*
  mv phantomjs-1.9.1-linux-x86_64/bin/phantomjs /usr/bin
  chown vagrant:vagrant /usr/bin/phantomjs
  rm -rf phantomjs*
}

install_redis() {
  msg "Install redis-server"
  useradd -p redis redis
  apt-get -y install redis-server
  echo "su -c 'redis-server' redis" >> /etc/rc.local
}
