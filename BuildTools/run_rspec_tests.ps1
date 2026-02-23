$SCRIPTDIR = $PSScriptRoot
$COMPOSE_FILE="${SCRIPTDIR}\docker-compose.yml"
$SERVICE_NAME="ruby"

$tests = "./test/"
#$tests = "./test/features/volunteer_tasks_spec.rb"
docker compose -f "$COMPOSE_FILE" exec $SERVICE_NAME /bin/bash -c "RAILS_ENV=test LOG_LEVEL=warn bundle exec rspec ${tests} --fail-fast=1"