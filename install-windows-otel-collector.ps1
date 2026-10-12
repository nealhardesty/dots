#!/usr/bin/env pwsh
#Requires -RunAsAdministrator

<#
.SYNOPSIS
  Install the OpenTelemetry collector (contrib distribution) as a Windows service.

.DESCRIPTION
  Windows counterpart to install-macos-otel-collector.sh.

  Takes a zip containing config.yaml, ca.crt, bundle.pem, client.crt and client.key.
  config.yaml from the zip is only read to pull the otlp exporter endpoint out of it;
  a Windows-appropriate config is generated here, because the vendor config targets
  linux (journald, k8s, /proc, unix socket paths) and will not load on Windows.

  Differences from the macOS script, all forced by platform support:
    - docker_stats is NOT included. Its metadata declares
      unsupported_platforms: [darwin, windows], so there is no docker receiver here
      and no conditional launcher is needed.
    - The hostmetrics 'processes' scraper is NOT included. It is linux/macOS only
      and would be a fatal config error on Windows.
    - windows_event_log replaces filelog / macos_unified_logging. It honours
      start_at: end and keeps bookmarks in the file_storage extension, so unlike the
      macOS unified log receiver there is no 24h replay on restart.
    - The collector writes its own logs to the Windows Event Log when run as a
      service, so the Application channel receiver excludes the collector's own
      provider to avoid ingesting its own output.

.PARAMETER ZipPath
  Path to the mTLS zip.

.EXAMPLE
  .\install-windows-otel-collector.ps1 C:\Users\neal\Downloads\otel-collector-mtls.zip
.EXAMPLE
  .\install-windows-otel-collector.ps1 -Status
#>

[CmdletBinding(DefaultParameterSetName = 'Install')]
param(
    [Parameter(ParameterSetName = 'Install', Position = 0, Mandatory = $true)]
    [string]$ZipPath,

    # otlp endpoint, instead of the one in the zip's config.yaml
    [Parameter(ParameterSetName = 'Install')]
    [string]$Endpoint,

    # collector version, instead of the latest release
    [Parameter(ParameterSetName = 'Install')]
    [string]$Version,

    # event log channels to collect
    [Parameter(ParameterSetName = 'Install')]
    [string[]]$EventChannels = @('Application', 'System'),

    [Parameter(ParameterSetName = 'Uninstall')][switch]$Uninstall,
    [Parameter(ParameterSetName = 'Start')][switch]$Start,
    [Parameter(ParameterSetName = 'Stop')][switch]$Stop,
    [Parameter(ParameterSetName = 'Status')][switch]$Status
)

$ErrorActionPreference = 'Stop'

$ServiceName = 'otelcol-contrib'
$DisplayName = 'OpenTelemetry Collector (contrib)'
$InstallDir  = Join-Path $env:ProgramFiles 'otelcol-contrib'
$ExePath     = Join-Path $InstallDir 'otelcol-contrib.exe'
$DataDir     = Join-Path $env:ProgramData 'otelcol-contrib'
$CertDir     = Join-Path $DataDir 'certs'
$StateDir    = Join-Path $DataDir 'state'
$LogDir      = Join-Path $DataDir 'logs'
$ConfPath    = Join-Path $DataDir 'config.yaml'
$VendorConf  = Join-Path $DataDir 'config.yaml.vendor'
$LogPath     = Join-Path $LogDir 'otelcol.log'
$CaFile      = Join-Path $CertDir 'ca.crt'
$CertFile    = Join-Path $CertDir 'client.crt'
$KeyFile     = Join-Path $CertDir 'client.key'
$Repo        = 'open-telemetry/opentelemetry-collector-releases'

# native commands do not throw on failure, so check them explicitly
function Invoke-Native {
    param([string]$File, [string[]]$Arguments, [string]$What)
    & $File @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "$What failed (exit $LASTEXITCODE): $File $($Arguments -join ' ')"
    }
}

function Get-OtelService {
    Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
}

function Stop-OtelService {
    $svc = Get-OtelService
    if ($svc -and $svc.Status -ne 'Stopped') {
        Write-Host "stopping $ServiceName"
        Stop-Service -Name $ServiceName -Force
        $svc.WaitForStatus('Stopped', [TimeSpan]::FromSeconds(30))
    }
}

function Remove-OtelService {
    if (Get-OtelService) {
        Stop-OtelService
        Write-Host "removing existing service $ServiceName"
        # Remove-Service is PowerShell 6+, sc.exe works everywhere
        & sc.exe delete $ServiceName | Out-Null
        Start-Sleep -Seconds 2
    }
}

switch ($PSCmdlet.ParameterSetName) {
    'Stop' {
        Stop-OtelService
        exit 0
    }
    'Start' {
        if (-not (Get-OtelService)) { throw "not installed: service $ServiceName" }
        Restart-Service -Name $ServiceName
        Get-Service -Name $ServiceName | Format-Table -AutoSize
        exit 0
    }
    'Status' {
        $svc = Get-OtelService
        if (-not $svc) { Write-Host 'not installed'; exit 0 }
        $svc | Format-Table Name, Status, StartType -AutoSize
        Write-Host "config: $ConfPath"
        Write-Host "logs:   $LogPath"
        Write-Host 'recent collector events:'
        Get-WinEvent -LogName Application -MaxEvents 5 `
            -FilterXPath "*[System[Provider[@Name='$ServiceName']]]" -ErrorAction SilentlyContinue |
            Format-Table TimeCreated, LevelDisplayName, Message -AutoSize
        exit 0
    }
    'Uninstall' {
        Remove-OtelService
        if ([System.Diagnostics.EventLog]::SourceExists($ServiceName)) {
            Remove-EventLog -Source $ServiceName -ErrorAction SilentlyContinue
        }
        foreach ($p in @($InstallDir, $DataDir)) {
            if (Test-Path $p) { Remove-Item -Path $p -Recurse -Force; Write-Host "removed $p" }
        }
        Write-Host 'uninstalled'
        exit 0
    }
}

# ---------------------------------------------------------------- preflight

if (-not (Test-Path -LiteralPath $ZipPath)) { throw "no such file: $ZipPath" }

if (-not (Get-Command tar.exe -ErrorAction SilentlyContinue)) {
    throw 'tar.exe is required (ships with Windows 10 1803+ / Server 2019+)'
}

# Windows PowerShell 5.1 defaults to TLS 1.0 for Invoke-WebRequest
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# the progress bar makes Invoke-WebRequest roughly an order of magnitude slower
# on Windows PowerShell 5.1, and this downloads a ~250MB tarball
$ProgressPreference = 'SilentlyContinue'

$archRaw = $env:PROCESSOR_ARCHITEW6432
if (-not $archRaw) { $archRaw = $env:PROCESSOR_ARCHITECTURE }
switch ($archRaw) {
    'AMD64' { $Arch = 'windows_amd64' }
    'ARM64' { $Arch = 'windows_arm64' }
    'x86'   { $Arch = 'windows_386' }
    default { throw "unsupported architecture: $archRaw" }
}

$Work = Join-Path ([System.IO.Path]::GetTempPath()) ("otelcol-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $Work -Force | Out-Null

try {
    # ------------------------------------------------------------ unpack the zip

    Expand-Archive -LiteralPath $ZipPath -DestinationPath $Work -Force

    # resolve by search rather than by path, so a zip that wraps everything in a
    # folder still works
    $zipFiles = @{}
    foreach ($f in @('config.yaml', 'ca.crt', 'client.crt', 'client.key', 'bundle.pem')) {
        $found = Get-ChildItem -LiteralPath $Work -Recurse -File -Filter $f | Select-Object -First 1
        if (-not $found) { throw "zip is missing $f" }
        $zipFiles[$f] = $found.FullName
    }

    # pull the first endpoint under the top level exporters: block
    if (-not $Endpoint) {
        $section = ''
        foreach ($line in Get-Content -LiteralPath $zipFiles['config.yaml']) {
            if ($line -match '^[^\s#]') {
                $section = ($line -split ':')[0].Trim()
            }
            elseif ($section -eq 'exporters' -and $line -match '^\s+endpoint:\s*(\S+)') {
                $Endpoint = $Matches[1].Trim([char[]]@('"', "'"))
                break
            }
        }
    }
    if (-not $Endpoint) { throw 'could not find an otlp exporter endpoint in config.yaml (use -Endpoint)' }
    Write-Host "otlp endpoint: $Endpoint"

    # ------------------------------------------------------------ install binary

    if (-not $Version) {
        $rel = Invoke-RestMethod -Uri "https://api.github.com/repos/$Repo/releases/latest" `
            -Headers @{ 'User-Agent' = 'otelcol-installer' } -UseBasicParsing
        $Version = $rel.tag_name -replace '^v', ''
    }
    if (-not $Version) { throw 'could not determine latest release (use -Version)' }
    Write-Host "installing otelcol-contrib $Version ($Arch)"

    $tarball = "otelcol-contrib_${Version}_${Arch}.tar.gz"
    $tarPath = Join-Path $Work $tarball
    Invoke-WebRequest -Uri "https://github.com/$Repo/releases/download/v$Version/$tarball" `
        -OutFile $tarPath -UseBasicParsing

    # the windows tarball contains README.md and otelcol-contrib.exe
    Invoke-Native -File 'tar.exe' -Arguments @('-xzf', $tarPath, '-C', $Work, 'otelcol-contrib.exe') -What 'tar extract'

    Remove-OtelService

    foreach ($d in @($InstallDir, $DataDir, $CertDir, $StateDir, $LogDir)) {
        New-Item -ItemType Directory -Path $d -Force | Out-Null
    }

    Copy-Item -LiteralPath (Join-Path $Work 'otelcol-contrib.exe') -Destination $ExePath -Force

    # ------------------------------------------------------------ install certs

    foreach ($f in @('ca.crt', 'client.crt', 'client.key', 'bundle.pem')) {
        Copy-Item -LiteralPath $zipFiles[$f] -Destination (Join-Path $CertDir $f) -Force
    }
    Copy-Item -LiteralPath $zipFiles['config.yaml'] -Destination $VendorConf -Force

    # lock the private key to SYSTEM and Administrators. SIDs rather than names so
    # this still works on a non-English Windows.
    Invoke-Native -File 'icacls.exe' -Arguments @(
        $KeyFile, '/inheritance:r',
        '/grant:r', '*S-1-5-18:(R)',
        '/grant:r', '*S-1-5-32-544:(R)'
    ) -What 'icacls on client.key'

    # ------------------------------------------------------------ generate config

    $eventReceivers = ''
    $eventPipeline = @()
    foreach ($ch in $EventChannels) {
        $id = "windows_event_log/" + $ch.ToLower()
        $eventPipeline += $id
        $eventReceivers += @"
  ${id}:
    channel: $ch
    start_at: end
    storage: file_storage
    exclude_providers:
      - $ServiceName

"@
    }
    $logsReceivers = (($eventPipeline + 'otlp') -join ', ')

    $config = @"
# generated by install-windows-otel-collector.ps1 - re-running the installer
# overwrites this file. the config shipped in the mtls zip is kept at
# config.yaml.vendor for reference; it targets linux and will not load here.

extensions:
  file_storage:
    directory: '$StateDir'
    create_directory: true

receivers:
  host_metrics:
    collection_interval: 30s
    scrapers:
      cpu:
        metrics:
          system.cpu.utilization:
            enabled: true
      disk: {}
      filesystem: {}
      load: {}
      memory: {}
      network: {}
      paging: {}
      # 'processes' is omitted on purpose: it is linux/macos only and is a fatal
      # config error on windows. the 'process' scraper IS supported on windows but
      # is left out by default because it is expensive; add it here if wanted.
$eventReceivers  otlp:
    protocols:
      grpc:
        endpoint: 127.0.0.1:4317
      http:
        endpoint: 127.0.0.1:4318

processors:
  memory_limiter:
    limit_mib: 512
    spike_limit_mib: 128
    check_interval: 5s
  resource_detection:
    detectors:
      - env
      - system
    override: false
    system:
      hostname_sources:
        - os
      resource_attributes:
        host.id:
          enabled: true
        host.ip:
          enabled: true
        host.mac:
          enabled: true
        os.version:
          enabled: true
        os.description:
          enabled: true
  batch:
    timeout: 5s
    send_batch_size: 1000

exporters:
  otlp_grpc:
    endpoint: $Endpoint
    tls:
      ca_file: '$CaFile'
      cert_file: '$CertFile'
      key_file: '$KeyFile'
    retry_on_failure:
      enabled: true
      initial_interval: 5s
      max_interval: 60s
      max_elapsed_time: 10m
    sending_queue:
      enabled: true
      num_consumers: 4
      queue_size: 5000
      storage: file_storage

service:
  extensions: [file_storage]
  pipelines:
    metrics:
      receivers: [host_metrics, otlp]
      processors: [memory_limiter, resource_detection, batch]
      exporters: [otlp_grpc]
    logs:
      receivers: [$logsReceivers]
      processors: [memory_limiter, resource_detection, batch]
      exporters: [otlp_grpc]
    traces:
      receivers: [otlp]
      processors: [memory_limiter, resource_detection, batch]
      exporters: [otlp_grpc]
  telemetry:
    logs:
      level: info
      output_paths:
        - '$LogPath'
"@

    # -Encoding UTF8 emits a BOM on Windows PowerShell 5.1, so write it explicitly
    # without one rather than rely on the YAML parser tolerating it
    [System.IO.File]::WriteAllText($ConfPath, $config, (New-Object System.Text.UTF8Encoding $false))

    Write-Host "validating $ConfPath"
    Invoke-Native -File $ExePath -Arguments @('validate', '--config', "file:$ConfPath") -What 'config validation'

    # ------------------------------------------------------------ install service

    # the collector opens an event log source named after the service and fails to
    # start (1501) if that cannot be opened, so register the source up front.
    if (-not [System.Diagnostics.EventLog]::SourceExists($ServiceName)) {
        New-EventLog -LogName Application -Source $ServiceName
    }

    # the collector calls svc.Run first and falls back to interactive if it was not
    # started by the service control manager, so no extra flag is needed here.
    $binaryPath = '"{0}" --config "{1}"' -f $ExePath, $ConfPath
    New-Service -Name $ServiceName -BinaryPathName $binaryPath -DisplayName $DisplayName `
        -Description 'Collects host metrics, event logs and OTLP data and forwards them over mTLS.' `
        -StartupType Automatic | Out-Null

    # restart on failure, the rough equivalent of launchd KeepAlive
    Invoke-Native -File 'sc.exe' -Arguments @(
        'failure', $ServiceName, 'reset=', '86400',
        'actions=', 'restart/5000/restart/10000/restart/30000'
    ) -What 'service recovery options'

    Start-Service -Name $ServiceName
    (Get-Service -Name $ServiceName).WaitForStatus('Running', [TimeSpan]::FromSeconds(30))

    Write-Host ''
    Write-Host 'installed:'
    Write-Host "  binary   $ExePath"
    Write-Host "  config   $ConfPath"
    Write-Host "  certs    $CertDir"
    Write-Host "  state    $StateDir"
    Write-Host "  service  $ServiceName"
    Write-Host "  logs     $LogPath (and the Application event log)"
    Write-Host ''
    Write-Host "status:    .\install-windows-otel-collector.ps1 -Status"
    Write-Host "stop:      .\install-windows-otel-collector.ps1 -Stop"
    Write-Host "tail:      Get-Content -Wait '$LogPath'"
    Write-Host "uninstall: .\install-windows-otel-collector.ps1 -Uninstall"
    Write-Host "           removes the $ServiceName service and event log source,"
    Write-Host "           $InstallDir and $DataDir"
    Write-Host "           (certs, private key, state and logs all live under $DataDir)"
}
finally {
    if (Test-Path -LiteralPath $Work) { Remove-Item -LiteralPath $Work -Recurse -Force -ErrorAction SilentlyContinue }
}
