#!/bin/sh
echo 'alias bam_prod="psql -U postgres be_amazing_production"' >> /home/cftuser/.bash_profile
echo 'alias sc="cd /usr/local/cft/deploy/rails && ruby script/console production"' >> /home/cftuser/.bash_profile