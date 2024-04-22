# Shell script to build and run the docker container for the API

# Checking if the environment variables are set
if [ -z "$PROJECT_NAME" ]; then
    echo "PROJECT_NAME is not set"
    exit 1
fi

if [ -z "$DOCKERFILE_PATH_API" ]; then
    echo "DOCKERFILE_PATH_API is not set"
    exit 1
fi

if [ -z "$DEV"]; then
    $DEV=""
else
    $DEV="-dev"
fi

if [ -z "$EXTRA_ARGS_BUILD_API" ]; then
    EXTRA_ARGS_BUILD_API=""
fi

if [ -z "$EXTRA_ARGS_RUN_API" ]; then
    EXTRA_ARGS_RUN_API=""
fi

# Build the docker image
docker build -t ${PROJECT_NAME}-api${DEV}:latest -f ${DOCKERFILE_PATH_API} ${EXTRA_ARGS_BUILD_API} ./${PROJECT_NAME}.API

# Run the docker container
docker run --rm -d --name ${PROJECT_NAME}-api${DEV} ${EXTRA_ARGS_RUN_API} ${PROJECT_NAME}-api${DEV}:latest

# If not ran from another script, remove the dangling images (see if an argument is passed)
if [ -z "$1" ]; then
    docker image prune -f
fi

# Follow the logs
docker logs -f ${PROJECT_NAME}-api${DEV} &

# If the container is running, stop it during the SIGINT signal
trap 'if [ "$(docker ps -q -f name=${PROJECT_NAME}-api${DEV})" ];then docker stop ${PROJECT_NAME}-api${DEV}; fi' SIGINT

# Wait for the container to stop
wait

