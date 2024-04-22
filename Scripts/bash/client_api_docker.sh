# Shell script to run the client + API in Docker

# Checking if the environment variables are set
if [ -z "$PROJECT_NAME" ]; then
    echo "PROJECT_NAME is not set"
    exit 1
fi

# Running the client
cmd /c start "NodeClient" bash "Scripts/bash/client_docker.sh true"

# Run the API
bash Scripts/bash/api_docker.sh true