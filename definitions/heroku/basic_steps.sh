msg() {
  echo "******************************************************"
  echo "$1"
  echo "******************************************************"
}

basic_libraries() {
  msg "Apt-install various things necessary for Ruby, guest additions, etc., and remove optional things to trim down the machine."
  apt-get -y update
  apt-get -y upgrade
  apt-get -y install linux-headers-$(uname -r) build-essential
  apt-get -y install zlib1g-dev libssl-dev libreadline5-dev
  apt-get -y install git-core vim
  apt-get -y install libyaml-dev

  msg "Apt-install python tools and libraries libpq-dev lets us compile psycopg for Postgres"
  apt-get -y install python-setuptools python-dev libpq-dev pep8
}

basic_user_config() {
  msg  "Setup sudo to allow no-password sudo for 'admin'"
  cp /etc/sudoers /etc/sudoers.orig
  sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
  sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers

  msg "Install NFS client"
  apt-get -y install nfs-common

  msg "Installing vagrant keys"
  mkdir /home/vagrant/.ssh
  chmod 700 /home/vagrant/.ssh
  cd /home/vagrant/.ssh
  wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
  chmod 600 /home/vagrant/.ssh/authorized_keys
  chown -R vagrant /home/vagrant/.ssh

  msg "Installing the virtualbox guest additions"
  VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
  cd /home/vagrant
  mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
  sh /mnt/VBoxLinuxAdditions.run
  umount /mnt

  rm VBoxGuestAdditions_$VBOX_VERSION.iso
}

cleanup() {
  msg "Zero out the free space to save space in the final image"
  dd if=/dev/zero of=/EMPTY bs=1M
  rm -f /EMPTY

  msg "Removing leftover leases and persistent rules"
  echo "cleaning up dhcp leases"
  rm /var/lib/dhcp3/*

  msg "Make sure Udev doesn't block our network http://6.ptmc.org/?p=164"
  echo "cleaning up udev rules"
  rm /etc/udev/rules.d/70-persistent-net.rules
  mkdir /etc/udev/rules.d/70-persistent-net.rules
  rm -rf /dev/.udev/
  rm /lib/udev/rules.d/75-persistent-net-generator.rules

  msg "Install Heroku toolbelt"
  wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

  msg "Install some libraries"
  apt-get -y install libxml2-dev libxslt-dev curl libcurl4-openssl-dev
  apt-get -y install imagemagick libmagickcore-dev libmagickwand-dev
  apt-get clean

  msg "Set locale"
  echo 'LC_ALL="en_US.UTF-8"' >> /etc/default/locale

  echo "Adding a 2 sec delay to the interface up, to make the dhclient happy"
  echo "pre-up sleep 2" >> /etc/network/interfaces
}
