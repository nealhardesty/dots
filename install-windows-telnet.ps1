# Windows Telnet Client Installation Script
param(
    [switch]$Force
)

# Check if already installed
try {
    $telnetFeature = Get-WindowsOptionalFeature -Online -FeatureName "TelnetClient" -ErrorAction SilentlyContinue
    if ($telnetFeature -and $telnetFeature.State -eq "Enabled") {
        if (-not $Force) {
            Write-Host "Telnet Client is already installed and enabled" -ForegroundColor Green
            exit 0
        }
    }
}
catch {
    # Feature not found or error occurred, continue with installation
}

Write-Host "Installing Windows Telnet Client..." -ForegroundColor Green

# Install Telnet Client using DISM
try {
    Enable-WindowsOptionalFeature -Online -FeatureName "TelnetClient" -All -NoRestart
    $exitCode = $LASTEXITCODE
}
catch {
    Write-Host "Error installing Telnet Client: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

if ($exitCode -eq 0) {
    Write-Host "Telnet Client installation completed successfully" -ForegroundColor Green
    
    # Verify installation
    try {
        $telnetFeature = Get-WindowsOptionalFeature -Online -FeatureName "TelnetClient" -ErrorAction SilentlyContinue
        if ($telnetFeature -and $telnetFeature.State -eq "Enabled") {
            Write-Host "Verification successful: Telnet Client is now enabled" -ForegroundColor Green
            
            # Test if telnet command is available
            try {
                $telnetVersion = telnet 2>&1 | Select-String "Microsoft"
                if ($telnetVersion) {
                    Write-Host "Telnet command is available and working" -ForegroundColor Green
                } else {
                    Write-Host "Warning: Telnet command may not be available in current session" -ForegroundColor Yellow
                    Write-Host "You may need to restart your terminal or computer" -ForegroundColor Yellow
                }
            }
            catch {
                Write-Host "Warning: Could not verify telnet command availability" -ForegroundColor Yellow
            }
        } else {
            Write-Host "Warning: Telnet Client feature not found or not enabled" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Warning: Could not verify Telnet Client installation" -ForegroundColor Yellow
    }
} else {
    Write-Host "Installation failed with exit code: $exitCode" -ForegroundColor Red
    exit 1
}
