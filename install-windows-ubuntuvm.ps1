#Requires -RunAsAdministrator

param(
    [string]$VMName = "Ubuntu",
    [int]$MemoryGB = 4,
    [int]$DiskSizeGB = 120,
    [int]$ProcessorCount = 4
)

# Check admin privileges
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator"
    exit 1
}

Write-Host "Creating Ubuntu VM: $VMName" -ForegroundColor Green

# Enable Hyper-V if needed
$hyperVFeature = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
if ($hyperVFeature.State -eq "Disabled") {
    Write-Host "Enabling Hyper-V..." -ForegroundColor Yellow
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -All -NoRestart
    Write-Host "Hyper-V enabled. Restart may be required." -ForegroundColor Yellow
}

# Download Ubuntu ISO
$isoUrl = "https://releases.ubuntu.com/24.04.3/ubuntu-24.04.3-desktop-amd64.iso"
$isoPath = "$env:USERPROFILE\Downloads\ubuntu-24.04.3-desktop-amd64.iso"

if (-not (Test-Path $isoPath)) {
    Write-Host "Downloading Ubuntu ISO..." -ForegroundColor Cyan
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($isoUrl, $isoPath)
    $webClient.Dispose()
    Write-Host "Download complete" -ForegroundColor Green
}

# Create VM directory
$vmPath = "C:\VMDATA\$VMName"
if (-not (Test-Path $vmPath)) {
    New-Item -ItemType Directory -Path $vmPath -Force | Out-Null
}

# Remove existing VM if it exists
$existingVM = Get-VM -Name $VMName -ErrorAction SilentlyContinue
if ($existingVM) {
    Write-Host "Removing existing VM..." -ForegroundColor Yellow
    if ($existingVM.State -ne "Off") {
        Stop-VM -Name $VMName -Force
    }
    Remove-VM -Name $VMName -Force
}

# Remove existing VHD file if it exists
$vhdPath = "$vmPath\$VMName.vhdx"
if (Test-Path $vhdPath) {
    Write-Host "Removing existing VHD file..." -ForegroundColor Yellow
    Remove-Item $vhdPath -Force
}

# Create VM
$memoryBytes = $MemoryGB * 1GB
$diskBytes = $DiskSizeGB * 1GB
$vhdPath = "$vmPath\$VMName.vhdx"

Write-Host "Creating VM..." -ForegroundColor Cyan
$vm = New-VM -Name $VMName -MemoryStartupBytes $memoryBytes -Path $vmPath -NewVHDPath $vhdPath -NewVHDSizeBytes $diskBytes -Generation 2

# Configure VM
Set-VM -Name $VMName -ProcessorCount $ProcessorCount
Set-VM -Name $VMName -AutomaticStartAction Nothing
Set-VM -Name $VMName -AutomaticStopAction ShutDown
Set-VMFirmware -VMName $VMName -EnableSecureBoot Off
Add-VMDvdDrive -VMName $VMName -Path $isoPath

# Connect network adapter to default switch
$networkAdapter = Get-VMNetworkAdapter -VMName $VMName
Connect-VMNetworkAdapter -VMNetworkAdapter $networkAdapter -SwitchName "Default Switch"

# Set boot order
$dvdDrive = Get-VMDvdDrive -VMName $VMName
Set-VMFirmware -VMName $VMName -FirstBootDevice $dvdDrive

# Start VM
Write-Host "Starting VM..." -ForegroundColor Cyan
Start-VM -Name $VMName

Write-Host "Ubuntu VM '$VMName' created and started successfully!" -ForegroundColor Green
Write-Host "Opening VM console..." -ForegroundColor Cyan
Start-Process "vmconnect.exe" -ArgumentList "localhost", $VMName
