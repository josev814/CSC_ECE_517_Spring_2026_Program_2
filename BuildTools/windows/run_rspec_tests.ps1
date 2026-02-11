param(
    [string]$Pattern = "*_spec.rb"
)

$SCRIPTDIR = $PSScriptRoot
$COMPOSE_FILE="${SCRIPTDIR}\..\docker-compose.yml"
$SERVICE_NAME="ruby"

function Gems-Installed {
    $gem_pkg = "rspec"
    $maxAttempts = 30
    $attempt = 0
    while ([int](docker compose -f "$COMPOSE_FILE" exec $SERVICE_NAME /bin/bash -c "bundle list | grep $gem_pkg | wc -l") -lt 2) {
        $attempt++
        if ($attempt -gt $maxAttempts) {
            Write-Host "$SERVICE_NAME service doesn't have $gem_pkg installed after $maxAttempts attempts" -ForegroundColor Red
            exit 1
        }
        Write-Host "Waiting for $SERVICE_NAME service to have $gem_pkg bundle installed... (attempt $attempt/$maxAttempts)" -ForegroundColor Yellow
        Start-Sleep -Seconds 10
    }
}

if ( -not (docker compose -f "$COMPOSE_FILE" ps -q $SERVICE_NAME)){
    docker compose -f "$COMPOSE_FILE" up -d
    # Wait for ruby service to be ready
    $maxAttempts = 30
    $attempt = 0

    while (-not (docker compose -f "$COMPOSE_FILE" ps -q $SERVICE_NAME)) {
        $attempt++
        if ($attempt -gt $maxAttempts) {
            Write-Host "Failed to start $SERVICE_NAME service after $maxAttempts attempts" -ForegroundColor Red
            exit 1
        }
        Write-Host "Waiting for $SERVICE_NAME service to start... (attempt $attempt/$maxAttempts)" -ForegroundColor Yellow
        Start-Sleep -Seconds 10
    }
    Write-Host "$SERVICE_NAME service started successfully!" -ForegroundColor Green

    Gems-Installed
}

docker compose -f "$COMPOSE_FILE" exec $SERVICE_NAME /bin/bash -c "bundle exec rspec /opt/project/spec/$Pattern"