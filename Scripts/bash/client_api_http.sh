# Shell script to run the client + API

# Checking if the environment variables are set
if [ -z "$PROJECT_NAME" ]; then
    echo "PROJECT_NAME is not set"
    exit 1
fi

# Checking if pnpm is installed
if ! command -v pnpm &> /dev/null
then
    corepack enable
    echo "Enabling pnpm"
fi

# Running the client
cmd /c start "NodeClient" bash -c "cd ${PROJECT_NAME}.Client && pnpm i && pnpm dev"

# Change the directory to the API
cd ${PROJECT_NAME}.API

# Run the API
dotnet run -c Debug --no-build