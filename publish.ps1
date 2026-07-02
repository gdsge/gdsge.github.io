# Build the Sphinx site and publish it to the repo root (served by GitHub Pages).
# Usage: .\publish.ps1
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

uv run sphinx-build -M clean source build
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

uv run sphinx-build -M html source build
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Copy-Item -Path build/html/* -Destination . -Recurse -Force
Write-Host 'Published build/html to repo root.'
