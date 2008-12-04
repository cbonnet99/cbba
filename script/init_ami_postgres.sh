#!/bin/sh

/etc/init.d/postgresql-8.3 reload

#just in case...
dropdb -U postgres be_amazing_production

createdb -U postgres be_amazing_production
psql be_amazing_production < /usr/local/cft/deploy/rails/db/be-amazing.sql
