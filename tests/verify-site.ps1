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
    'assets/images/jiahui-chen.jpg'
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
$cleanPages = @{}

foreach ($page in $htmlPages) {
    $html = Remove-HtmlComments (Get-Content -LiteralPath (Join-Path $siteRoot $page) -Raw -Encoding UTF8)
    $cleanPages[$page] = $html
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

$correctChineseName = -join [char[]](0x9648, 0x4F73, 0x6167)
$incorrectChineseName = -join [char[]](0x9648, 0x5609, 0x6167)

$requiredFacts = @(
    $correctChineseName
    'chenjh99@bit.edu.cn'
    'Duke University'
    'Sanford School of Public Policy'
    'assets/images/jiahui-chen.jpg'
)
foreach ($fact in $requiredFacts) {
    if (-not $allHtml.Contains($fact)) {
        throw "Missing refreshed fact: $fact"
    }
}

$forbiddenFacts = @(
    $incorrectChineseName
    'Jiahui.chen@duke.edu'
    '3120225853@bit.edu.cn'
    'chenjiahuicjf@163.com'
    '188-1178-7330'
    '5 Zhongguancun South Street'
    'Working paper'
    'Under Review'
    'Minor revision'
)
foreach ($fact in $forbiddenFacts) {
    if ($allHtml.Contains($fact)) {
        throw "Forbidden public content found: $fact"
    }
}

$publishedTitles = @(
    'Global public perceptions of climate change risks and their determinants'
    'Empowering women substantially accelerates the household clean energy transition in China'
    'Rural photovoltaic projects substantially prompt household energy transition'
    'Household Energy Transition Improves Children'
    'Weather, Travel Modes, and the Effectiveness of Driving Restriction Policies'
    'Decoupling carbon emissions, economic growth, and health costs toward carbon neutrality'
    'Public pension accelerates the household electrification'
)
$researchHtml = $cleanPages['research.html']
foreach ($title in $publishedTitles) {
    if (-not $researchHtml.Contains($title)) {
        throw "Missing published title: $title"
    }
}

$homeHtml = $cleanPages['index.html']
$forbiddenHomeSections = @('id="focus-title"', 'id="recent-title"', 'home-theme-grid')
foreach ($sectionMarker in $forbiddenHomeSections) {
    if ($homeHtml.Contains($sectionMarker)) {
        throw "Homepage still contains research content: $sectionMarker"
    }
}

if ($homeHtml.Contains('class="cn-name"')) {
    throw 'Homepage title still contains the Chinese name subtitle'
}

$heroTitle = [regex]::Match($homeHtml, '(?s)<h1\s+id="hero-title"[^>]*>(?<content>.*?)</h1>')
if (-not $heroTitle.Success -or $heroTitle.Groups['content'].Value.Contains($correctChineseName)) {
    throw 'Homepage hero title must show Jiahui Chen without the Chinese name'
}

$styles = Get-Content -LiteralPath (Join-Path $siteRoot 'assets/css/styles.css') -Raw -Encoding UTF8
$portraitFrameRule = [regex]::Match($styles, '(?s)\.portrait-frame\s*\{(?<declarations>.*?)\}')
if (-not $portraitFrameRule.Success -or $portraitFrameRule.Groups['declarations'].Value -notmatch 'aspect-ratio\s*:\s*1\s*/\s*1') {
    throw 'Portrait frame must use a square aspect ratio'
}
$portraitRule = [regex]::Match($styles, '(?s)\.portrait-frame img\s*\{(?<declarations>.*?)\}')
if (-not $portraitRule.Success) {
    throw 'Missing .portrait-frame img style rule'
}
if ($portraitRule.Groups['declarations'].Value -notmatch 'height\s*:\s*100%') {
    throw 'Portrait image must fill the circular frame height'
}
if ($portraitRule.Groups['declarations'].Value -notmatch 'border-radius\s*:\s*50%') {
    throw 'Portrait image must be circular'
}
if ($portraitRule.Groups['declarations'].Value -notmatch 'object-fit\s*:\s*cover') {
    throw 'Portrait image must preserve its proportions with object-fit: cover'
}

$displayTitleRule = [regex]::Match($styles, '(?s)\.display-title\s*\{(?<declarations>.*?)\}')
if (-not $displayTitleRule.Success -or $displayTitleRule.Groups['declarations'].Value -notmatch 'font-family\s*:\s*var\(--body\)') {
    throw 'Homepage display title must use the simple body typeface'
}

Write-Output 'Site verification passed.'
