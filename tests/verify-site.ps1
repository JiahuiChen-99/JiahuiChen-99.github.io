$ErrorActionPreference = 'Stop'

$siteRoot = Split-Path -Parent $PSScriptRoot
$requiredFiles = @(
    'index.html'
    'about.html'
    'research.html'
    'assets/css/styles.css'
    'assets/js/site.js'
    'Resume_Chenjiahui.pdf'
)

foreach ($relativePath in $requiredFiles) {
    $fullPath = Join-Path $siteRoot $relativePath
    if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
        throw "Missing required file: $relativePath"
    }
}

$htmlPages = @('index.html', 'about.html', 'research.html')
$requiredPageLinks = @('index.html', 'about.html', 'research.html')
$allHtml = ''

foreach ($page in $htmlPages) {
    $html = Get-Content -LiteralPath (Join-Path $siteRoot $page) -Raw
    $allHtml += "`n$html"

    foreach ($link in $requiredPageLinks) {
        if ($html -notmatch ('href\s*=\s*["''](?:\./)?' + [regex]::Escape($link) + '(?:[#?][^"'']*)?["'']')) {
            throw "$page does not link to $link"
        }
    }

    if ($html -notmatch 'data-en\s*=\s*["''][^"'']+["'']') {
        throw "$page does not contain data-en content"
    }
    if ($html -notmatch 'data-zh\s*=\s*["''][^"'']+["'']') {
        throw "$page does not contain data-zh content"
    }
    if ($html -notmatch 'href\s*=\s*["''](?:\./)?assets/css/styles\.css(?:\?[^"'']*)?["'']') {
        throw "$page does not load assets/css/styles.css"
    }
    if ($html -notmatch 'src\s*=\s*["''](?:\./)?assets/js/site\.js(?:\?[^"'']*)?["'']') {
        throw "$page does not load assets/js/site.js"
    }
}

$siteWideContent = @(
    @{ Value = 'tpFVbtoAAAAJ'; Label = 'Google Scholar user tpFVbtoAAAAJ' }
    @{ Value = '0000-0003-0874-3194'; Label = 'ORCID 0000-0003-0874-3194' }
    @{ Value = 'Resume_Chenjiahui.pdf'; Label = 'Resume_Chenjiahui.pdf link' }
)

foreach ($requirement in $siteWideContent) {
    if (-not $allHtml.Contains($requirement.Value)) {
        throw "Site HTML does not contain $($requirement.Label)"
    }
}

Write-Output 'Site verification passed.'
