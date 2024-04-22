# Shell script to build and run the docker container for the client

# Checking if the environment variables are set
if [ -z "$PROJECT_NAME" ]; then
    echo "PROJECT_NAME is not set"
    exit 1
fi

if [ -z "$DOCKERFILE_PATH_CLIENT" ]; then
    echo "DOCKERFILE_PATH_CLIENT is not set"
    exit 1
fi

if [ -z "$DEV"]; then
    $DEV=""
else
    $DEV="-dev"
fi

if [ -z "$EXTRA_ARGS_BUILD_CLIENT" ]; then
    EXTRA_ARGS_BUILD_CLIENT=""
fi

if [ -z "$EXTRA_ARGS_RUN_CLIENT" ]; then
    EXTRA_ARGS_RUN_CLIENT=""
fi

# Setting the working directory
cd ${PROJECT_NAME}.Client

# Build the docker image
docker build -t ${PROJECT_NAME}-client${DEV}:latest -f ${DOCKERFILE_PATH_CLIENT} ${EXTRA_ARGS_BUILD_CLIENT} ./${PROJECT_NAME}.Client

# Run the docker container
docker run --rm -d --name ${PROJECT_NAME}-client${DEV} ${EXTRA_ARGS_RUN_CLIENT} ${PROJECT_NAME}-client${DEV}:latest

# If not ran from another script, remove the dangling images (see if an argument is passed)
if [ -z "$1" ]; then
    docker image prune -f
fi

# Follow the logs
docker logs -f ${PROJECT_NAME}-client${DEV} &

# If the container is running, stop it during the SIGINT signal
trap 'if [ "$(docker ps -q -f name=${PROJECT_NAME}-client${DEV})" ]; then docker stop ${PROJECT_NAME}-client${DEV}; fi' SIGINT

# Wait for the container to stop
wait

