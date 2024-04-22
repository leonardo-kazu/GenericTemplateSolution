# Shell script to run the client + API in docker

# Checking if the environment variables are set
if (!$env:PROJECT_NAME) {
  Write-Host "PROJECT_NAME is not set"
  exit 1
}

# Running the client
Start-Process -FilePath "powershell.exe" -ArgumentList "-File", "Scripts/powershell/client_docker.ps1", "true"

# Run the API
. .\Scripts\powershell\api_docker.ps1 "$true"

# On closing prune dangling images
Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action {
  docker image prune -f
}