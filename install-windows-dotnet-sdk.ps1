# .NET 6.0 SDK Installation Script using Chocolatey
param(
    [switch]$Force
)

# Check if already installed
try {
    $dotnetVersion = dotnet --version 2>$null
    if ($dotnetVersion -and $dotnetVersion.StartsWith("6.")) {
        if (-not $Force) {
            Write-Host ".NET 6.0 SDK is already installed (version: $dotnetVersion)"
            exit 0
        }
    }
}
catch {
    # dotnet command not found, continue with installation
}

Write-Host "Installing .NET 6.0 SDK via Chocolatey..."
choco install dotnet-6.0-sdk -y

if ($LASTEXITCODE -eq 0) {
    Write-Host ".NET 6.0 SDK installation completed successfully"
    
    # Verify installation by checking dotnet version
    try {
        $dotnetVersion = dotnet --version 2>$null
        if ($dotnetVersion -and $dotnetVersion.StartsWith("6.")) {
            Write-Host "Verification successful: .NET $dotnetVersion is now available"
        } else {
            Write-Host "Warning: dotnet command found but version doesn't start with 6.x"
        }
    }
    catch {
        Write-Host "Warning: Could not verify dotnet installation - command not found"
    }
} else {
    Write-Host "Installation failed"
    exit 1
} 