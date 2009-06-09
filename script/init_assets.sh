#!/bin/sh
DIRECTORY=/usr/local/cft/deploy/capistrano/shared/assets
if [ ! -d "$DIRECTORY" ]; then
  mkdir "$DIRECTORY"
  chown -R cftuser "$DIRECTORY"
fi