$dockerPath = "$Env:ProgramFiles\Docker\Docker\Docker Desktop.exe"
if (Test-Path $dockerPath) {
    $dockerProcess = Get-Process -Name "Docker Desktop" -ErrorAction SilentlyContinue
    if ($dockerProcess) {
        Write-Host "Docker Desktop is already running." -ForegroundColor Green
    } else {
        Write-Host "Docker Desktop is installed but not running. Starting it now..." -ForegroundColor Cyan
        Start-Process "$dockerPath"
    }
    exit
}

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit
}

$wslFeature = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

if ($wslFeature.State -ne "Enabled") {
    Write-Host "WSL is not enabled. Enabling now..."  -ForegroundColor Red
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
    Write-Host "WSL has been enabled. Please restart your computer and run this script again." -ForegroundColor Green
    exit
}

$downloadsPath = [Environment]::GetFolderPath("UserProfile") + "\Downloads"

Write-Host "Downloading Docker Desktop Installer"
Invoke-WebRequest -Uri "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe" `
  -OutFile "$downloadsPath\DockerDesktopInstaller.exe"

Write-Host "Starting Docker Desktop Installer, you will need to follow the guided prompts to install docker desktop"
Start-Process "$downloadsPath\DockerDesktopInstaller.exe"

Write-Host "You can remove $downloadsPath\DockerDesktopInstaller.exe after installation is complete."