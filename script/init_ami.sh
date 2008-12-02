#!/bin/sh
sudo cp /usr/local/cft/deploy/apache_modrails.conf /usr/local/cft/deploy/apache_modrails.conf.SAV
sudo cp /usr/local/cft/deploy/rails/apache/apache_modrails.conf /usr/local/cft/deploy/apache_modrails.conf

sudo cp /etc/postgresql/8.3/main/pg_hba.conf /etc/postgresql/8.3/main/pg_hba.conf.SAV
sudo cp /usr/local/cft/deploy/rails/postgres/pg_hba.conf /etc/postgresql/8.3/main/pg_hba.conf
sudo su - postgres
/etc/init.d/postgresql-8.3 reload
logout
createdb -U postgres be_amazing_production

psql -U postgres be_amazing_production < /usr/local/cft/deploy/rails/db/2008-11-31-be-amazing.sql
sudo /etc/init.d/cft-rails-apache-modrails stop
sudo /etc/init.d/cft-rails-apache-modrails start