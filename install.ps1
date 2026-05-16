# PowerShell installation script for cgo on Windows
# Run with: .\install.ps1

$ErrorActionPreference = "Stop"

# Default install location (can be overridden with CGO_INSTALL_DIR env var)
$INSTALL_DIR = if ($env:CGO_INSTALL_DIR) { $env:CGO_INSTALL_DIR } else { "$env:USERPROFILE\.local\bin" }

Write-Host "  Installing cgo → $INSTALL_DIR\cgo" -ForegroundColor Cyan

# Create install directory if it doesn't exist
New-Item -ItemType Directory -Force -Path $INSTALL_DIR | Out-Null

# Copy the cgo script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Copy-Item "$scriptDir\cgo" -Destination "$INSTALL_DIR\cgo" -Force

# Create a wrapper batch file for easy execution
$batchContent = "@echo off`npython `"%~dp0cgo`" %*"
Set-Content -Path "$INSTALL_DIR\cgo.bat" -Value $batchContent

Write-Host ""
Write-Host "  Installing windows-curses package..." -ForegroundColor Cyan
pip install windows-curses

# Check if install directory is in PATH
$pathParts = $env:PATH -split ";"
$installDirInPath = $pathParts -contains $INSTALL_DIR

if (-not $installDirInPath) {
    Write-Host ""
    Write-Host "  ⚠  $INSTALL_DIR is not on your PATH." -ForegroundColor Yellow
    Write-Host "  Add it to your system PATH or run this command:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "    `$env:PATH += `";$INSTALL_DIR`"" -ForegroundColor White
    Write-Host ""
    Write-Host "  To make it permanent, add $INSTALL_DIR to your User PATH in System Environment Variables" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "  Done. Run: cgo" -ForegroundColor Green
