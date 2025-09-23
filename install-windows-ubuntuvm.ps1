#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Automated Ubuntu VM creation script for Hyper-V

.DESCRIPTION
    This script automates the process of:
    1. Enabling Hyper-V feature
    2. Downloading the latest Ubuntu LTS ISO
    3. Creating a Ubuntu VM with sane defaults
    4. Starting the VM for installation

.PARAMETER VMName
    Name of the virtual machine (default: Ubuntu)

.PARAMETER MemoryGB
    Memory allocation in GB (default: 8)

.PARAMETER DiskSizeGB
    Virtual disk size in GB (default: 120)

.PARAMETER ProcessorCount
    Number of virtual processors (default: 4)

.EXAMPLE
    .\install-windows-ubuntuvm.ps1
    .\install-windows-ubuntuvm.ps1 -VMName "MyUbuntu" -MemoryGB 8 -DiskSizeGB 120
#>

param(
    [string]$VMName = "Ubuntu",
    [int]$MemoryGB = 8,
    [int]$DiskSizeGB = 120,
    [int]$ProcessorCount = 4
)

# Color output functions
function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Write-Success { param([string]$Message) Write-ColorOutput $Message "Green" }
function Write-Info { param([string]$Message) Write-ColorOutput $Message "Cyan" }
function Write-Warning { param([string]$Message) Write-ColorOutput $Message "Yellow" }
function Write-Error { param([string]$Message) Write-ColorOutput $Message "Red" }

# Script variables
$ErrorActionPreference = "Stop"
$ubuntuVersion = "22.04.3"
$isoFileName = "ubuntu-$ubuntuVersion-live-server-amd64.iso"
$isoUrl = "https://releases.ubuntu.com/22.04/$isoFileName"
$downloadsPath = [Environment]::GetFolderPath("UserProfile") + "\Downloads"
$isoPath = Join-Path $downloadsPath $isoFileName
$vmPath = "C:\Hyper-V\$VMName"
$vhdPath = Join-Path $vmPath "$VMName.vhdx"
$switchName = "Default Switch"
$memoryStartupBytes = $MemoryGB * 1GB
$vhdSizeBytes = $DiskSizeGB * 1GB

Write-Info "=== Ubuntu VM Installation Script ==="
Write-Info "VM Name: $VMName"
Write-Info "Memory: $MemoryGB GB"
Write-Info "Disk Size: $DiskSizeGB GB"
Write-Info "Processors: $ProcessorCount"
Write-Info "========================================`n"

try {
    # Step 1: Check if running as Administrator
    Write-Info "Step 1: Checking administrator privileges..."
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        throw "This script must be run as Administrator. Please restart PowerShell as Administrator."
    }
    Write-Success "✓ Running with administrator privileges"

    # Step 2: Enable Hyper-V
    Write-Info "`nStep 2: Checking and enabling Hyper-V..."
    $hyperVFeature = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
    
    if ($hyperVFeature.State -eq "Disabled") {
        Write-Warning "Hyper-V is not enabled. Enabling now..."
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -All -NoRestart
        Write-Warning "Hyper-V has been enabled. A system restart may be required."
        Write-Warning "Please restart your computer and run this script again if the VM creation fails."
    } else {
        Write-Success "✓ Hyper-V is already enabled"
    }

    # Check if Hyper-V services are running
    $hvService = Get-Service -Name vmms -ErrorAction SilentlyContinue
    if ($hvService -and $hvService.Status -eq "Running") {
        Write-Success "✓ Hyper-V Virtual Machine Management service is running"
    } else {
        Write-Warning "Hyper-V service is not running. Attempting to start..."
        Start-Service -Name vmms -ErrorAction SilentlyContinue
    }

    # Step 3: Download Ubuntu ISO
    Write-Info "`nStep 3: Downloading Ubuntu LTS ISO..."
    if (Test-Path $isoPath) {
        $existingFile = Get-Item $isoPath
        $fileSizeMB = [math]::Round($existingFile.Length / 1MB, 2)
        Write-Info "Ubuntu ISO already exists: $isoPath ($fileSizeMB MB)"
        
        $response = Read-Host "Do you want to re-download? (y/N)"
        if ($response -eq "y" -or $response -eq "Y") {
            Remove-Item $isoPath -Force
        } else {
            Write-Success "✓ Using existing Ubuntu ISO"
        }
    }
    
    if (-not (Test-Path $isoPath)) {
        Write-Info "Downloading Ubuntu $ubuntuVersion LTS ISO..."
        Write-Info "URL: $isoUrl"
        Write-Info "Destination: $isoPath"
        
        # Create a WebClient with progress reporting
        $webClient = New-Object System.Net.WebClient
        $webClient.Headers.Add("User-Agent", "PowerShell Ubuntu VM Installer")
        
        # Progress event handler
        Register-ObjectEvent -InputObject $webClient -EventName DownloadProgressChanged -Action {
            $percent = $Event.SourceEventArgs.ProgressPercentage
            $received = [math]::Round($Event.SourceEventArgs.BytesReceived / 1MB, 2)
            $total = [math]::Round($Event.SourceEventArgs.TotalBytesToReceive / 1MB, 2)
            Write-Progress -Activity "Downloading Ubuntu ISO" -Status "$percent% Complete" -PercentComplete $percent -CurrentOperation "$received MB / $total MB"
        } | Out-Null
        
        try {
            $webClient.DownloadFile($isoUrl, $isoPath)
            Write-Progress -Activity "Downloading Ubuntu ISO" -Completed
            Write-Success "✓ Ubuntu ISO downloaded successfully"
        } finally {
            $webClient.Dispose()
        }
    }

    # Verify ISO file
    if (Test-Path $isoPath) {
        $isoFile = Get-Item $isoPath
        $fileSizeMB = [math]::Round($isoFile.Length / 1MB, 2)
        Write-Success "✓ ISO file verified: $fileSizeMB MB"
    } else {
        throw "Failed to download Ubuntu ISO"
    }

    # Step 4: Create VM directory
    Write-Info "`nStep 4: Creating VM directory..."
    if (-not (Test-Path $vmPath)) {
        New-Item -ItemType Directory -Path $vmPath -Force | Out-Null
        Write-Success "✓ Created VM directory: $vmPath"
    } else {
        Write-Success "✓ VM directory already exists: $vmPath"
    }

    # Step 5: Check if VM already exists
    Write-Info "`nStep 5: Checking for existing VM..."
    $existingVM = Get-VM -Name $VMName -ErrorAction SilentlyContinue
    if ($existingVM) {
        Write-Warning "VM '$VMName' already exists!"
        $response = Read-Host "Do you want to remove it and create a new one? (y/N)"
        if ($response -eq "y" -or $response -eq "Y") {
            if ($existingVM.State -ne "Off") {
                Write-Info "Stopping VM..."
                Stop-VM -Name $VMName -Force
            }
            Write-Info "Removing existing VM..."
            Remove-VM -Name $VMName -Force
            if (Test-Path $vhdPath) {
                Remove-Item $vhdPath -Force
                Write-Info "Removed existing VHD file"
            }
        } else {
            Write-Info "Exiting without changes."
            exit 0
        }
    }

    # Step 6: Create the VM
    Write-Info "`nStep 6: Creating Ubuntu VM..."
    Write-Info "Creating VM with the following specifications:"
    Write-Info "- Name: $VMName"
    Write-Info "- Memory: $MemoryGB GB"
    Write-Info "- Disk: $DiskSizeGB GB"
    Write-Info "- Processors: $ProcessorCount"
    Write-Info "- Generation: 2 (UEFI)"

    # Check if Default Switch exists, create if not
    $defaultSwitch = Get-VMSwitch -Name $switchName -ErrorAction SilentlyContinue
    if (-not $defaultSwitch) {
        Write-Warning "Default Switch not found. Creating internal switch..."
        $switchName = "Internal Switch"
        New-VMSwitch -Name $switchName -SwitchType Internal | Out-Null
        Write-Success "✓ Created internal switch: $switchName"
    }

    # Create the VM
    $vm = New-VM -Name $VMName -MemoryStartupBytes $memoryStartupBytes -Path $vmPath -NewVHDPath $vhdPath -NewVHDSizeBytes $vhdSizeBytes -Generation 2 -SwitchName $switchName
    Write-Success "✓ Virtual machine created successfully"

    # Step 7: Configure VM settings
    Write-Info "`nStep 7: Configuring VM settings..."
    
    # Set processor count
    Set-VM -Name $VMName -ProcessorCount $ProcessorCount
    Write-Success "✓ Set processor count to $ProcessorCount"
    
    # Enable dynamic memory
    Set-VM -Name $VMName -DynamicMemory -MemoryMinimumBytes (1GB) -MemoryMaximumBytes ($memoryStartupBytes * 2)
    Write-Success "✓ Configured dynamic memory (Min: 1GB, Startup: $MemoryGB GB, Max: $($MemoryGB * 2)GB)"
    
    # Disable Secure Boot (required for Ubuntu)
    Set-VMFirmware -VMName $VMName -EnableSecureBoot Off
    Write-Success "✓ Disabled Secure Boot"
    
    # Add DVD drive and attach ISO
    Add-VMDvdDrive -VMName $VMName -Path $isoPath
    Write-Success "✓ Added DVD drive with Ubuntu ISO"
    
    # Set boot order (DVD first)
    $dvdDrive = Get-VMDvdDrive -VMName $VMName
    $networkAdapter = Get-VMNetworkAdapter -VMName $VMName
    $hardDrive = Get-VMHardDiskDrive -VMName $VMName
    Set-VMFirmware -VMName $VMName -FirstBootDevice $dvdDrive -BootOrder $dvdDrive, $hardDrive, $networkAdapter
    Write-Success "✓ Set boot order (DVD, Hard Drive, Network)"

    # Enable nested virtualization (optional, for development)
    Set-VMProcessor -VMName $VMName -ExposeVirtualizationExtensions $true
    Write-Success "✓ Enabled nested virtualization"

    # Step 8: Display VM information
    Write-Info "`nStep 8: VM Configuration Summary"
    Write-Info "================================"
    $vmInfo = Get-VM -Name $VMName
    Write-Info "VM Name: $($vmInfo.Name)"
    Write-Info "State: $($vmInfo.State)"
    Write-Info "Memory: $($vmInfo.MemoryStartup / 1GB) GB (Dynamic: $($vmInfo.DynamicMemoryEnabled))"
    Write-Info "Processors: $($vmInfo.ProcessorCount)"
    Write-Info "Generation: $($vmInfo.Generation)"
    Write-Info "VHD Path: $vhdPath"
    Write-Info "ISO Path: $isoPath"

    # Step 9: Start the VM
    Write-Info "`nStep 9: Starting the VM..."
    Start-VM -Name $VMName
    Write-Success "✓ Virtual machine started successfully!"

    Write-Info "`n=== Installation Complete ==="
    Write-Success "✓ Ubuntu VM '$VMName' has been created and started"
    Write-Info "Next steps:"
    Write-Info "1. Connect to the VM using Hyper-V Manager or VMConnect"
    Write-Info "2. Follow the Ubuntu installation wizard"
    Write-Info "3. After installation, you may want to:"
    Write-Info "   - Install Hyper-V Integration Services"
    Write-Info "   - Configure network settings"
    Write-Info "   - Take a checkpoint after successful installation"
    
    Write-Info "`nTo connect to the VM, run:"
    Write-Info "vmconnect localhost '$VMName'"
    
} catch {
    Write-Error "❌ Error: $($_.Exception.Message)"
    Write-Info "Stack trace: $($_.ScriptStackTrace)"
    exit 1
} finally {
    # Cleanup any background jobs
    Get-Job | Remove-Job -Force -ErrorAction SilentlyContinue
}

Write-Info "`nScript completed successfully!"
