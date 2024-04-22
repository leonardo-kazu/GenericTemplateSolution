# PowerShell script to run the client

# Checking if the environment variables are set
if (!$env:PROJECT_NAME) {
  Write-Host "PROJECT_NAME is not set"
  exit 1
}

# Setting the working directory
Set-Location "${env:PROJECT_NAME}.Client"

# Checking if the pnpm is installed
if (!(Get-Command pnpm -ErrorAction SilentlyContinue)) {
  Write-Host "Enabling pnpm"
  corepack enable
}

# Install the dependencies
pnpm i

# Run the client
pnpm dev