param (
    [Parameter(Mandatory = $true)]
    [string]$Version
)

# Define variables
$githubUsername = "lymperis-e"
$repoName = "greek-open-data-portal"
$baseImageName = "ghcr.io/$githubUsername/$repoName"
$latestTag = "$baseImageName:latest"
$versionTag = "${baseImageName}:$Version"

# Prompt user to login interactively
Write-Host "`n👉 Please log in to GitHub Container Registry (ghcr.io)"
docker logout ghcr.io | Out-Null
docker login ghcr.io

if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ Docker login failed. Aborting."
    exit 1
}

# Build the Docker image
Write-Host "`n🔨 Building Docker image with tags:"
# Write-Host " - $latestTag"
Write-Host " - $versionTag"
docker build -t $versionTag .

if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ Docker build failed. Aborting."
    exit 1
}

# Push both tags to GHCR
Write-Host "`n🚀 Pushing both image tags to GHCR..."
# docker push $latestTag
docker push $versionTag

Write-Host "`n✅ Done. Image pushed as:"
# Write-Host " - $latestTag"
Write-Host " - $versionTag"
