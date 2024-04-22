# Shell script to run the client

# Checking if the environment variables are set
if [ -z "$PROJECT_NAME" ]; then
    echo "PROJECT_NAME is not set"
    exit 1
fi

# Setting the working directory
cd ${PROJECT_NAME}.Client

# Check if pnpm is installed
if ! command -v pnpm &> /dev/null
then
    echo "Enabling pnpm"
    corepack enable
fi

# Install the dependencies
pnpm i

# Run the client
pnpm dev