$SCRIPTDIR = $PSScriptRoot
$COMPOSE_FILE="${SCRIPTDIR}\docker-compose.yml"
$SERVICE_NAME="ruby"

docker compose -f "$COMPOSE_FILE" exec $SERVICE_NAME /bin/bash -c "bundle exec rspec ./test/"