$ErrorActionPreference = 'Stop'

function Remove-HtmlComments {
    param([string]$Html)

    return [regex]::Replace($Html, '<!--.*?-->', '', [System.Text.RegularExpressions.RegexOptions]::Singleline)
}

function Get-HtmlAttributeValues {
    param(
        [string]$Html,
        [string]$AttributeName
    )

    $escapedName = [regex]::Escape($AttributeName)
    $attributePattern = '(?i)(?<![A-Za-z0-9_:-])' + $escapedName + '\s*=\s*(["''])(.*?)\1'
    $values = foreach ($tagMatch in [regex]::Matches($Html, '<[^>]+>')) {
        foreach ($attributeMatch in [regex]::Matches($tagMatch.Value, $attributePattern)) {
            $attributeMatch.Groups[2].Value
        }
    }

    return @($values)
}

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
    $html = Remove-HtmlComments (Get-Content -LiteralPath (Join-Path $siteRoot $page) -Raw)
    $allHtml += "`n$html"
    $hrefValues = Get-HtmlAttributeValues $html 'href'
    $srcValues = Get-HtmlAttributeValues $html 'src'

    foreach ($link in $requiredPageLinks) {
        $linkPattern = '^(?:\./)?' + [regex]::Escape($link) + '(?:[#?].*)?$'
        if (-not ($hrefValues | Where-Object { $_ -match $linkPattern })) {
            throw "$page does not link to $link"
        }
    }

    if (-not (Get-HtmlAttributeValues $html 'data-en' | Where-Object { $_.Length -gt 0 })) {
        throw "$page does not contain data-en content"
    }
    if (-not (Get-HtmlAttributeValues $html 'data-zh' | Where-Object { $_.Length -gt 0 })) {
        throw "$page does not contain data-zh content"
    }
    if (-not ($hrefValues | Where-Object { $_ -match '^(?:\./)?assets/css/styles\.css(?:[?#].*)?$' })) {
        throw "$page does not load assets/css/styles.css"
    }
    if (-not ($srcValues | Where-Object { $_ -match '^(?:\./)?assets/js/site\.js(?:[?#].*)?$' })) {
        throw "$page does not load assets/js/site.js"
    }
}

$allHrefValues = Get-HtmlAttributeValues $allHtml 'href'

if (-not ($allHrefValues | Where-Object {
    $_ -match '^https://scholar\.google\.com/citations\?' -and
    $_ -match '(?:\?|&(?:amp;)?)user=tpFVbtoAAAAJ(?:&(?:amp;)?|#|$)'
})) {
    throw 'Site HTML does not link to Google Scholar user tpFVbtoAAAAJ'
}

if (-not ($allHrefValues | Where-Object {
    $_ -match '^https://orcid\.org/0000-0003-0874-3194/?(?:[?#].*)?$'
})) {
    throw 'Site HTML does not link to ORCID 0000-0003-0874-3194'
}

if (-not ($allHrefValues | Where-Object {
    $_ -match '^(?:\./)?Resume_Chenjiahui\.pdf(?:[?#].*)?$'
})) {
    throw 'Site HTML does not link to Resume_Chenjiahui.pdf'
}

Write-Output 'Site verification passed.'
