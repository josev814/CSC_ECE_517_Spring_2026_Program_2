#!/bin/bash

envfile='./BuildTools/.env'
if ! [ -f $envfile ]; then
  echo 'RAILS_ENV=development' > $envfile
  echo 'RAILS_PORT=80' >> $envfile
fi

sudo docker compose -f BuildTools/docker-compose.yml \
  -f BuildTools/docker-compose-watcher.yml \
  up --build --remove-orphans -d

