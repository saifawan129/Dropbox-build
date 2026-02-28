$root = $PSScriptRoot
$cdnBase = "https://cdn.prod.website-files.com/66c503d081b2f012369fc5d2/"
$downloadsFolders = @(
    "c:\Users\warri\Downloads\Color",
    "c:\Users\warri\Downloads\Logo",
    "c:\Users\warri\Downloads\Typography",
    "c:\Users\warri\Downloads\Voice-n-tone",
    "c:\Users\warri\Downloads\iconography",
    "c:\Users\warri\Downloads\imagery",
    "c:\Users\warri\Downloads\motion"
)

function Restore-Asset($path, $originFile) {
    # Extract filename from path (e.g. img/67..._foo.png or ../img/67..._foo.png)
    if ($path -match "([^/]+\.(png|webp|svg|riv|json|jpg|ico|gif))$") {
        $filename = $matches[1]
    }
    else {
        return
    }
    
    # Target directory based on origin file
    $subpageDir = Split-Path $originFile -Parent
    $targetDir = Join-Path $subpageDir "img"
    
    # If path starts with ../img/, it points to the parent img dir
    if ($path -like "../img/*") {
        $targetDir = Join-Path $root "img"
    }

    if (!(Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }
    
    $targetPath = Join-Path $targetDir $filename
    # Unescape filename for local check
    $localFilename = [uri]::UnescapeDataString($filename)
    $targetPathLocal = Join-Path $targetDir $localFilename

    if (Test-Path $targetPathLocal) {
        # File already exists, skip
        return
    }

    Write-Host "Restoring $localFilename for $(Split-Path $subpageDir -Leaf)..."
    
    # 1. Search in Downloads
    foreach ($dl in $downloadsFolders) {
        if (Test-Path $dl) {
            # Search for files containing the hash part (first 24 chars) or the exact name
            $hash = if ($localFilename -match "^([a-f0-9]{24})_") { $matches[1] } else { $null }
            
            $found = Get-ChildItem -Path $dl -Recurse -File | Where-Object { 
                $_.Name -eq $localFilename -or ($hash -and $_.Name -like "*$hash*") 
            } | Select-Object -First 1
            
            if ($found) {
                Write-Host "  Found in Downloads: $($found.FullName)"
                Copy-Item $found.FullName $targetPathLocal -Force
                return
            }
        }
    }

    # 2. Download from CDN
    $url = $cdnBase + $filename
    Write-Host "  Not found in Downloads. Querying CDN: $url"
    try {
        Invoke-WebRequest -Uri $url -OutFile $targetPathLocal -ErrorAction Stop
    }
    catch {
        # Try without unescaping just in case
        try {
            Invoke-WebRequest -Uri ($cdnBase + [uri]::EscapeDataString($filename)) -OutFile $targetPathLocal -ErrorAction Stop
        }
        catch {
            Write-Warning "  Failed to restore $localFilename"
        }
    }
}

# Scan all index.html files
$htmlFiles = Get-ChildItem -Path $root -Recurse -Filter *.html
foreach ($html in $htmlFiles) {
    Write-Host "Processing $($html.FullName)..."
    $content = Get-Content $html.FullName -Raw
    $modified = $false

    # 1. Match relative img paths: img/... or ../img/...
    $relativeMatches = [regex]::Matches($content, '(\.\./)*img/[A-Za-z0-9%._\-]+\.[A-Za-z0-9]+')
    foreach ($m in $relativeMatches) {
        Restore-Asset $m.Value $html.FullName
    }

    # 2. Match CDN URLs: https://cdn.prod.website-files.com/...
    $cdnMatches = [regex]::Matches($content, 'https://cdn\.prod\.website-files\.com/[A-Za-z0-9]+/[A-Za-z0-9%._\-]+\.[A-Za-z0-9]+')
    foreach ($m in $cdnMatches) {
        $url = $m.Value
        if ($url -match "([^/]+\.[A-Za-z0-9]+)$") {
            $filename = $matches[1]
            $localFilename = [uri]::UnescapeDataString($filename)
            
            # Determine target img dir relative to current HTML
            $subpageDir = Split-Path $html.FullName -Parent
            $targetImgDir = Join-Path $subpageDir "img"
            if (!(Test-Path $targetImgDir)) {
                New-Item -ItemType Directory -Path $targetImgDir -Force | Out-Null
            }
            $targetPathLocal = Join-Path $targetImgDir $localFilename

            # Download if not exists
            if (!(Test-Path $targetPathLocal)) {
                Write-Host "  Downloading CDN asset: $localFilename"
                try {
                    Invoke-WebRequest -Uri $url -OutFile $targetPathLocal -ErrorAction Stop
                }
                catch {
                    Write-Warning "  Failed to download $url"
                    continue
                }
            }

            # Replace CDN URL with local relative path
            $relativePath = "img/" + $filename
            $content = $content.Replace($url, $relativePath)
            $modified = $true
        }
    }

    if ($modified) {
        Set-Content $html.FullName $content
        Write-Host "  Updated HTML with local paths."
    }
}

Write-Host "Asset restoration complete!"
