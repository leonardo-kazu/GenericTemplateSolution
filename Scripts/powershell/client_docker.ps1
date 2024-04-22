# PowerShell script to build and run the docker container for the client

# Checking if the environment variables are set
if (!$env:PROJECT_NAME) {
  Write-Host "PROJECT_NAME is not set"
  exit 1
}

if (!$env:DOCKERFILE_PATH_CLIENT) {
  Write-Host "DOCKERFILE_PATH_CLIENT is not set"
  exit 1
}

if (!$env:DEV) {
  $env:DEV = ""
} else {
  $env:DEV = "-dev"
}

if (!$env:EXTRA_ARGS_BUILD_CLIENT) {
  $env:EXTRA_ARGS_BUILD_CLIENT = ""
}

if (!$env:EXTRA_ARGS_RUN_CLIENT) {
  $env:EXTRA_ARGS_RUN_CLIENT = ""
}
# Setting the working directory
Set-Location "${env:PROJECT_NAME}.Client"

# Build the docker image
docker build -t "${env:PROJECT_NAME}-client${env.DEV}:latest" -f $env.DOCKERFILE_PATH_CLIENT $env:EXTRA_ARGS_BUILD_CLIENT .\"${env:PROJECT_NAME}.Client"

# Run the docker container
docker run --rm -d --name "${env:PROJECT_NAME}-client${env.DEV}" $env:EXTRA_ARGS_RUN_CLIENT "${env:PROJECT_NAME}-client${env.DEV}:latest"

# If not ran from another script, remove the dangling images (see if an argument is passed)
if (!$args[0]) {
  docker image prune -f
}

# Follow the logs
Start-Job -ScriptBlock { docker logs -f "${env:PROJECT_NAME}-client${env.DEV}" }

# If the container is running, stop it during the SIGINT signal
Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action {
  if (docker ps -q -f name="${env:PROJECT_NAME}-client${env.DEV}") {
      docker stop "${env:PROJECT_NAME}-client${env.DEV}"
  }
}

# Wait for the container to stop
Wait-Job -State Running