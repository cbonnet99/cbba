#!/bin/sh
sudo cp /usr/local/cft/deploy/apache_modrails.conf /usr/local/cft/deploy/apache_modrails.conf.SAV
sudo cp /usr/local/cft/deploy/rails/apache/apache_modrails.conf /usr/local/cft/deploy/apache_modrails.conf

sudo cp /etc/postgresql/8.3/main/pg_hba.conf /etc/postgresql/8.3/main/pg_hba.conf.SAV
sudo cp /usr/local/cft/deploy/rails/postgres/pg_hba.conf /etc/postgresql/8.3/main/pg_hba.conf

sudo /etc/init.d/cft-rails-apache-modrails stop
sudo /etc/init.d/cft-rails-apache-modrails start

sudo sudo -u postgres  /usr/local/cft/deploy/rails/script/init_ami_postgres.sh
