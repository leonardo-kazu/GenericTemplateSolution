# PowerShell script to build and run the docker container for the API

# Checking if the environment variables are set
if (!$env:PROJECT_NAME) {
  Write-Host "PROJECT_NAME is not set"
  exit 1
}

if (!$env:DOCKERFILE_PATH_API) {
  Write-Host "DOCKERFILE_PATH_API is not set"
  exit 1
}

if (!$env:DEV) {
  $env:DEV = ""
} else {
  $env:DEV = "-dev"
}

if (!$env:EXTRA_ARGS_BUILD_API) {
  $env:EXTRA_ARGS_BUILD_API = ""
}

if (!$env:EXTRA_ARGS_RUN_API) {
  $env:EXTRA_ARGS_RUN_API = ""
}

# Build the docker image
docker build -t "${env:PROJECT_NAME}-api${env:DEV}:latest" -f $env.DOCKERFILE_PATH_API $env:EXTRA_ARGS_BUILD_API .\"${env:PROJECT_NAME}.API"

# Run the docker container
docker run --rm -d --name "${env:PROJECT_NAME}-api${env:DEV}" $env:EXTRA_ARGS_RUN_API "${env:PROJECT_NAME}-api${env:DEV}:latest"

# If not ran from another script, remove the dangling images (see if an argument is passed)
if (!$args[0]) {
  docker image prune -f
}

# Remove dangling images
docker image prune -f

# Follow the logs
Start-Job -ScriptBlock { docker logs -f "${env:PROJECT_NAME}-api${env:DEV}" }

# If the container is running, stop it during the SIGINT signal
Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action {
  if (docker ps -q -f name="${env:PROJECT_NAME}-api${env:DEV}") {
      docker stop "${env:PROJECT_NAME}-api${env:DEV}"
  }
}

# Wait for the container to stop
Wait-Job -State Running