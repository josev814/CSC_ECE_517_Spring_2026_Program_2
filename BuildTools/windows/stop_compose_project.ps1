param(
    [switch]$RemoveImages,
    [switch]$RemoveVolumes
)

$SCRIPTDIR = $PSScriptRoot
$COMPOSE_FILE="${SCRIPTDIR}\..\docker-compose.yml"

if ( -not (docker compose -f "$COMPOSE_FILE" ps -q $SERVICE_NAME)){
    Write-Host "Compose Project is already stopped" -ForegroundColor Green
}
$extra_args=@()
if ( $RemoveImages ){
    $extra_args += "--rmi"
    $extra_args += "all"
}
if ( $RemoveVolumes ){
    $extra_args += "--volumes"
}
docker compose -f "$COMPOSE_FILE" down --remove-orphans @extra_args