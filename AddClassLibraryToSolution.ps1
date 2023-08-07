param (
    [string]$SolutionDirectory,
    [string]$SolutionName,
    [string]$ProjectName
)

# Validate solution directory
if (-not (Test-Path $SolutionDirectory -PathType Container)) {
    Write-Host "Solution directory does not exist."
    exit
}

# Find solution file
$SolutionPath = Get-ChildItem -Path $SolutionDirectory -Filter "$SolutionName.sln" -Recurse | Select-Object -ExpandProperty FullName

if (-not $SolutionPath) {
    $SolutionSubfolder = Join-Path -Path $SolutionDirectory -ChildPath "$SolutionName\$SolutionName"
    $SolutionPath = Get-ChildItem -Path $SolutionSubfolder -Filter "$SolutionName.sln" -Recurse | Select-Object -ExpandProperty FullName

    if (-not $SolutionPath) {
        Write-Host "Solution file '$SolutionName.sln' not found in '$SolutionDirectory' or its subdirectories."
        exit
    }
}

# Create MyLibrary directory within the solution directory
$MyLibraryDirectory = Join-Path -Path $SolutionDirectory -ChildPath "$SolutionName\$ProjectName"

# Use dotnet CLI to create class library project
Start-Process -Wait -FilePath dotnet -ArgumentList "new classlib -n $ProjectName -o $MyLibraryDirectory"

# Add project to solution
Start-Process -Wait -FilePath dotnet -ArgumentList "sln $SolutionPath add $MyLibraryDirectory\$ProjectName.csproj"

Write-Host "Class library project '$ProjectName' added to solution '$SolutionName'."
