# PowerShell script to run the client + API

# Checking if the environment variables are set
if (!$env:PROJECT_NAME) {
  Write-Host "PROJECT_NAME is not set"
  exit 1
}

# Checking if pnpm is installed
if (!(Get-Command pnpm -ErrorAction SilentlyContinue)) {
  corepack enable
  Write-Host "Enabling pnpm"
}

# Running the client
Start-Process -NoNewWindow -FilePath "cmd.exe" -ArgumentList "/c", "start", "NodeClient", "bash", "-c", "cd ${env:PROJECT_NAME}.Client && pnpm i && pnpm dev"

# Change the directory to the API
Set-Location "${env:PROJECT_NAME}.API"

# Run the API
dotnet run -c Debug --no-build