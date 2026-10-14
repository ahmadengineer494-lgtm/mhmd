param(
    [Parameter(Mandatory=$true)] [string]$Title,
    [Parameter(Mandatory=$true)] [string]$Category,
    [Parameter(Mandatory=$true)] [string]$MediaPath
)
$filename = Split-Path $MediaPath -Leaf
if (!(Test-Path "assets/works")) { New-Item -ItemType Directory -Path "assets/works" | Out-Null }
Copy-Item $MediaPath "assets/works/$filename" -Force
$type = if ($filename -match '\.(mp4|webm|mov)$') { "video" } else { "image" }
$jsonPath = "assets/works.json"
$json = if (Test-Path $jsonPath) { Get-Content $jsonPath -Raw | ConvertFrom-Json } else { @() }
if ($null -eq $json) { $json = @() }
$entry = [PSCustomObject]@{
    title = $Title
    category = $Category
    media = "assets/works/$filename"
    type = $type
    description = ""
}
$json = @($json) + $entry
$json | ConvertTo-Json -Depth 5 | Set-Content $jsonPath -Encoding UTF8
Write-Host "Added: $Title"
