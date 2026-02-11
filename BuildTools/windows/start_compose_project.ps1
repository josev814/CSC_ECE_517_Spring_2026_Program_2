param(
    [switch]$BuildImages,
    [switch]$ForceRecreate,
    [switch]$NoWatch,
    [switch]$NoCache
)

$SCRIPTDIR = $PSScriptRoot
$COMPOSE_FILE="${SCRIPTDIR}\..\docker-compose.yml"
$COMPOSE_WATCH_FILE="${SCRIPTDIR}\..\docker-compose-watcher.yml"
$SERVICE_NAME="ruby"

function Gems-Installed {
    $maxAttempts = 30
    $interval = 10
    $attempt = 0
    while ([int](docker compose -f "$COMPOSE_FILE" exec $SERVICE_NAME /bin/bash -c 'bundle check >/dev/null 2>&1; echo $?') -ne 0) {
        $attempt++
        if ($attempt -gt $maxAttempts) {
            Write-Host "$SERVICE_NAME service doesn't have $gem_pkg installed after $maxAttempts attempts" -ForegroundColor Red
            exit 1
        }
        Write-Host "Waiting for $SERVICE_NAME service to have $gem_pkg bundle installed... (attempt $attempt/$maxAttempts)" -ForegroundColor Yellow
        Start-Sleep -Seconds $interval
    }
}

$extra_args=@()
$extra_args += "--remove-orphans"

if ( docker compose -f "$COMPOSE_FILE" ps -q $SERVICE_NAME ){
    Write-Host "$SERVICE_NAME service already running" -ForegroundColor Green
    return
}

if ( $ForceRecreate ){
    $extra_args += "--force-recreate"
}

if ( $BuildImages ){
    $extra_args += "--build"
}

if ( $NoCache ){
    docker buildx prune -af
}

$watcher=@()
if ( -not $NoWatch ){
    $extra_args += "--watch"
    $watcher += "-f"
    $watcher += "${COMPOSE_WATCH_FILE}"
    echo "Using compose watch"
    echo @watcher
} else {
    $extra_args += "--detach"
}

$env:DOCKER_BUILDKIT=1

echo "Using docker compose args:"
echo @extra_args
docker compose -f "$COMPOSE_FILE" @watcher up @extra_args

# Wait for ruby service to be ready
$maxAttempts = 30
$interval = 10
$attempt = 0

while (-not (docker compose -f "$COMPOSE_FILE" ps -q $SERVICE_NAME)) {
    $attempt++
    if ($attempt -gt $maxAttempts) {
        Write-Host "Failed to start $SERVICE_NAME service after $maxAttempts attempts" -ForegroundColor Red
        exit 1
    }
    Write-Host "Waiting for $SERVICE_NAME service to start... (attempt $attempt/$maxAttempts)" -ForegroundColor Yellow
    Start-Sleep -Seconds $interval
}

Gems-Installed

Write-Host "$SERVICE_NAME service started successfully!" -ForegroundColor Green

$attempt = 0

sleep 1

docker compose -f "$COMPOSE_FILE" logs 2>&1 | Select-Object -Last 1
while ((docker compose -f "$COMPOSE_FILE" logs 2>&1 | Select-Object -Last 1) -notmatch "Use Ctrl-C to stop$") {
    $attempt++
    if ($attempt -gt $maxAttempts) {
        Write-Host "Rails failed to get into running state after $maxAttempts attempts" -ForegroundColor Red
        exit 1
    }
    docker compose -f "$COMPOSE_FILE" logs 2>&1 | Select-Object -Last 1
    Write-Host "Waiting for rails server to start... (attempt $attempt/$maxAttempts)" -ForegroundColor Yellow
    Start-Sleep -Seconds $interval
}
Write-Host "Rails Server is Now Running" -ForegroundColor Green