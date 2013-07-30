#!/usr/bin/env bash

date > /etc/vagrant_box_build_time

. ./basic_steps.sh
. ./install_steps.sh

basic_libraries
basic_user_config

install_zsh_and_autoenv_script
install_ruby_and_rubygems
install_python_and_virtualenv
install_node_and_npm

install_phantomjs
install_postgres
install_redis

cleanup

exit
