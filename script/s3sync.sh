#!/bin/sh
export AWS_ACCESS_KEY_ID=09M23471K1QC4FPBN9R2
export AWS_SECRET_ACCESS_KEY=vMIWZ6w/0b8PAdQIj2nZMjJ9aijbgX1mdpWe/fRI

find /home/cyrille/backups/* -type f -mtime +14 | xargs rm -Rf
/home/cyrille/s3sync/s3sync.rb --debug -r /home/cyrille/backups/ backups.beamazing.co.nz:/ > /home/cyrille/s3sync.log 2> /home/cyrille/s3sync.log