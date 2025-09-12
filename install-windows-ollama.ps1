#!/usr/bin/env pwsh

# Install Ollama for Windows and pull the same models as install-ubuntu-ollama.sh
# https://ollama.com/download/windows

Write-Host "Installing Ollama for Windows..." -ForegroundColor Green

# Download and install Ollama
$ollamaUrl = "https://github.com/ollama/ollama/releases/latest/download/OllamaSetup.exe"
$installerPath = "$env:TEMP\OllamaSetup.exe"

try {
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($ollamaUrl, $installerPath)
    $webClient.Dispose()
    
    # Try to run the installer with minimal interaction
    # The installer will show GUI but we'll wait for it to complete
    Write-Host "Starting Ollama installer (GUI will appear)..." -ForegroundColor Yellow
    $installProcess = Start-Process -FilePath $installerPath -Wait -PassThru
    
    if ($installProcess.ExitCode -eq 0) {
        Write-Host "Ollama installation completed!" -ForegroundColor Green
    } else {
        Write-Warning "Installation completed with exit code: $($installProcess.ExitCode)"
    }
} catch {
    Write-Error "Failed to install Ollama: $_"
    exit 1
} finally {
    # Clean up installer
    if (Test-Path $installerPath) {
        Remove-Item $installerPath -Force
    }
}

# Wait for Ollama service to start
Start-Sleep -Seconds 10

# Verify installation
try {
    $version = & ollama --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Ollama installed successfully: $version" -ForegroundColor Green
    } else {
        Write-Warning "Ollama command not found in PATH. You may need to restart your terminal or add it manually."
    }
} catch {
    Write-Warning "Could not verify Ollama installation. Please check if it's running."
}

Write-Host "Pulling models..." -ForegroundColor Green

& ollama pull llama3.1:8b
& ollama pull codellama
& ollama pull gpt-oss
& ollama pull deepseek-r1:8b
& ollama pull qwen2.5-coder:7b

Write-Host "Installation and model pulling completed!" -ForegroundColor Green
