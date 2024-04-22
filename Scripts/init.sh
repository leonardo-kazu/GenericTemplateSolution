# Shell script for initializing the project

# Variables
SHELL="bash"
SHELL_EXT=".sh"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SHELL_START="->"
TEMPLATE="GenericTemplateSolution"

# Colors
red="\033[0;31m"
normal="\e[1;37m"

echo "${SHELL_START} Initializing project..."
echo "${SHELL_START} Choose a name for the project: "



# Loop for checking if the project name is valid (string)
while true; do
    read PROJECT_NAME
    if [[ $PROJECT_NAME =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        # Confirm the project name
        echo -e "${SHELL_START} Confirm project name: ${red}${PROJECT_NAME}${normal} [Y]/n"
        read confirm
        # If confirm is not Y or y or RETURN, ask for the project name again
        if [[ $confirm == "Y" || $confirm == "y" || $confirm == "" ]]; then
            break
        else
            echo -e "${SHELL_START} Choose a name for the project: "
        fi
    else
        echo -e "${normal}Invalid project name. Please enter a valid name, must follow the REGEX (${red}^[a-zA-Z_][a-zA-Z0-9_]*\$${normal}): "
    fi
done

echo "${SHELL_START} Changing to root directory..."

# Changing to the root directory of the project
cd $SCRIPT_DIR \
  && cd ../

echo "${SHELL_START} Renaming variables..."


# Rename all the $TEMPLATE (GenericTempalteSolution) text in the project solution
echo "${SHELL_START} Renaming $TEMPLATE texts to $PROJECT_NAME..."
sed -i "s/$TEMPLATE/$PROJECT_NAME/g" $(grep -rl --exclude-dir={.vs,obj,bin,node_modules,Scripts} $TEMPLATE .) 2>/dev/null

# Rename the %PROJECT_NAME% variables
echo "${SHELL_START} Renaming %PROJECT_NAME% variables..."
sed -i "s/%PROJECT_NAME%/$PROJECT_NAME/g" $(grep -rl --exclude-dir={.vs,obj,bin,node_modules,Scripts} %PROJECT_NAME% .) 2>/dev/null

# Rename the %SHELL% variables
echo "${SHELL_START} Renaming %SHELL% variables..."
sed -i "s/%SHELL%/$SHELL/g" $(grep -rl --exclude-dir={.vs,obj,bin,node_modules,Scripts} %SHELL% .) 2>/dev/null

# Rename the %SHELL_EXT% variables
echo "${SHELL_START} Renaming %SHELL_EXT% variables..."
sed -i "s/%SHELL_EXT%/$SHELL_EXT/g" $(grep -rl --exclude-dir={.vs,obj,bin,node_modules,Scripts} %SHELL_EXT% .) 2>/dev/null

# Rename all the files and directories in the project solution
echo "${SHELL_START} Renaming all files and directories..."
# Get all directories that match the template name
directories=$(find . -mindepth 1 -maxdepth 1 -type d -name "*$TEMPLATE*")
# Loop through all the directories
for directory in $directories; do
    # Rename the directory
    new_dir="${directory//"$TEMPLATE"/"$PROJECT_NAME"}"
    mv "$directory" "$new_dir"

    # Rename the files inside the new directory
    find "$new_dir" -mindepth 1 -maxdepth 1 -type f -name "*$TEMPLATE*" -exec bash -c 'mv "$0" "${0//'"$TEMPLATE"'/'"$PROJECT_NAME"'}' {} \;
done

mv "${TEMPLATE}.sln" "${PROJECT_NAME}.sln"

echo "${SHELL_START} Project initialized successfully!"