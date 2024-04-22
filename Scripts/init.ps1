# PowerShell script for initializing the project

# Variables
$SHELL="powershell"
$SHELL_EXT=".ps1"
$SCRIPT_DIR = Split-Path $MyInvocation.MyCommand.Path
$SHELL_START="->"
$TEMPLATE="GenericTemplateSolution"

# Colors
$red = "Red"
$normal = "White"

Write-Host "${SHELL_START} Initializing project..."
Write-Host "${SHELL_START} Choose a name for the project: "

# Loop for checking if the project name is valid (string)
while ($true) {
    $PROJECT_NAME = Read-Host
    if ($PROJECT_NAME -match "^[a-zA-Z_][a-zA-Z0-9_]*$") {
        # Confirm the project name
        Write-Host "${SHELL_START} Confirm project name: " -NoNewline
        Write-Host "${PROJECT_NAME}" -NoNewline -ForegroundColor $red
        Write-Host " [Y]/n"
        $confirm = Read-Host
        # If confirm is not Y or y or RETURN, ask for the project name again
        if ($confirm -eq "Y" -or $confirm -eq "y" -or $confirm -eq "") {
            break
        } else {
            Write-Host "${SHELL_START} Choose a name for the project: "
        }
    } else {
        Write-Host "Invalid project name. Please enter a valid name, must follow the REGEX (" -NoNewline
        Write-Host "`^[a-zA-Z_][a-zA-Z0-9_]*`$): " -ForegroundColor $red
    }
}

Write-Host "${SHELL_START} Changing to root directory..."

# Changing to the root directory of the project
Set-Location $SCRIPT_DIR
Set-Location ..

Write-Host "${SHELL_START} Renaming variables..."

# Rename all the $TEMPLATE (GenericTempalteSolution) text in the project solution
Write-Host "${SHELL_START} Renaming $TEMPLATE texts to $PROJECT_NAME..."
Get-ChildItem -Recurse | ? ({$_.FullName -notMatch "\\node_modules\\|\\.vs\\|\\obj\\|\\bin\\|\\Scripts\\"}) | ForEach-Object {
  if($_ -is [System.IO.FileInfo]) {
    (Get-Content $_.FullName) | ForEach-Object { $_ -replace $TEMPLATE, $PROJECT_NAME } | Set-Content $_.FullName
  }
}

# Rename the %PROJECT_NAME% variables
Write-Host "${SHELL_START} Renaming %PROJECT_NAME% variables..."

Get-ChildItem -Recurse | ? ({$_.FullName -notMatch "\\node_modules\\|\\.vs\\|\\obj\\|\\bin\\|\\Scripts\\"}) | ForEach-Object {
  if($_ -is [System.IO.FileInfo]) {
    (Get-Content $_.FullName) | ForEach-Object { $_ -replace "%PROJECT_NAME%", $PROJECT_NAME } | Set-Content $_.FullName
  }
}
# Rename the %SHELL% variables
Write-Host "${SHELL_START} Renaming %SHELL% variables..."
Get-ChildItem -Recurse | ? ({$_.FullName -notMatch "\\node_modules\\|\\.vs\\|\\obj\\|\\bin\\|\\Scripts\\"}) | ForEach-Object {
  if($_ -is [System.IO.FileInfo]) {
    (Get-Content $_.FullName) | ForEach-Object { $_ -replace "%SHELL%", $SHELL } | Set-Content $_.FullName
  }
}


# Rename the %SHELL_EXT% variables
Write-Host "${SHELL_START} Renaming %SHELL_EXT% variables..."
Get-ChildItem -Recurse | ? ({$_.FullName -notMatch "\\node_modules\\|\\.vs\\|\\obj\\|\\bin\\|\\Scripts\\"}) | ForEach-Object {
  if($_ -is [System.IO.FileInfo]) {
    (Get-Content $_.FullName) | ForEach-Object { $_ -replace "%SHELL_EXT%", $SHELL_EXT } | Set-Content $_.FullName
  }
}
# Rename all the files and directories in the project solution
Write-Host "${SHELL_START} Renaming all files and directories..."
Get-ChildItem -Recurse | ? ({$_.FullName -notMatch "\\node_modules\\|\\.vs\\|\\obj\\|\\bin\\|\\Scripts\\"}) | ForEach-Object {
  Rename-Item -Path $_.FullName -NewName ($_.Name -replace $TEMPLATE, $PROJECT_NAME) 2>&1 | Out-Null
}

Write-Host "${SHELL_START} Project initialized successfully!"