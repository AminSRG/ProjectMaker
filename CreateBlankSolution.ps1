param (
    [string]$InputDirectory,
    [string]$ProjectName
)

# Validate input directory
if (-not (Test-Path $InputDirectory -PathType Container)) {
    Write-Host "Input directory does not exist."
    exit
}

# Create solution directory
$SolutionDirectory = Join-Path -Path $InputDirectory -ChildPath $ProjectName
New-Item -Path $SolutionDirectory -ItemType Directory

# Use dotnet CLI to create blank solution
$SolutionPath = Join-Path -Path $SolutionDirectory -ChildPath "$ProjectName.sln"
dotnet new sln -n $ProjectName -o $SolutionDirectory

Write-Host "Blank solution '$ProjectName' created in '$InputDirectory'."
