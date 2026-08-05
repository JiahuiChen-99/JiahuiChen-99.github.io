# Bilingual Academic Website Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a polished, responsive, bilingual three-page academic website for Jiahui Chen from the supplied resume, with verified Google Scholar and ORCID links.

**Architecture:** Use three semantic HTML documents with a shared stylesheet and a small progressive-enhancement JavaScript module. English content is the no-JavaScript default; bilingual values use `data-en`/`data-zh`, language preference persists in `localStorage`, and all paths remain relative for GitHub Pages.

**Tech Stack:** HTML5, CSS3, vanilla JavaScript, PowerShell link/content checks, GitHub Pages.

---

## File Structure

- `index.html`: home page, hero, featured publication, research themes, contact links.
- `about.html`: biography, education, skills, fieldwork/service, and selected awards.
- `research.html`: research themes, peer-reviewed article, working papers, and undergraduate projects.
- `assets/css/styles.css`: shared tokens, layout, typography, motion, responsive navigation, and accessibility states.
- `assets/js/site.js`: language selection, translated metadata, mobile navigation, active navigation, and reveal enhancement.
- `tests/verify-site.ps1`: deterministic checks for required files, internal links, bilingual attributes, external profile URLs, and CV availability.
- `Resume_Chenjiahui.pdf`: source resume and downloadable CV.

### Task 1: Add a Static-Site Verification Harness

**Files:**
- Create: `tests/verify-site.ps1`

- [ ] **Step 1: Write the failing verification script**

```powershell
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$required = @(
  'index.html', 'about.html', 'research.html',
  'assets/css/styles.css', 'assets/js/site.js',
  'Resume_Chenjiahui.pdf'
)

foreach ($relative in $required) {
  $path = Join-Path $root $relative
  if (-not (Test-Path -LiteralPath $path)) { throw "Missing required file: $relative" }
}

$pages = 'index.html', 'about.html', 'research.html'
foreach ($page in $pages) {
  $content = Get-Content -Raw -Encoding UTF8 (Join-Path $root $page)
  foreach ($link in $pages) {
    if ($content -notmatch [regex]::Escape("href=\"$link\"")) {
      throw "$page does not link to $link"
    }
  }
  if ($content -notmatch 'data-en=' -or $content -notmatch 'data-zh=') {
    throw "$page lacks bilingual content attributes"
  }
  if ($content -notmatch 'assets/css/styles\.css') { throw "$page lacks shared CSS" }
  if ($content -notmatch 'assets/js/site\.js') { throw "$page lacks shared JS" }
}

$allHtml = ($pages | ForEach-Object { Get-Content -Raw -Encoding UTF8 (Join-Path $root $_) }) -join "`n"
if ($allHtml -notmatch 'https://scholar\.google\.com/citations\?user=tpFVbtoAAAAJ') { throw 'Missing Scholar URL' }
if ($allHtml -notmatch 'https://orcid\.org/0000-0003-0874-3194') { throw 'Missing ORCID URL' }
if ($allHtml -notmatch 'Resume_Chenjiahui\.pdf') { throw 'Missing CV link' }

Write-Output 'Site verification passed.'
```

- [ ] **Step 2: Run the script and verify it fails before implementation**

Run: `powershell -ExecutionPolicy Bypass -File tests/verify-site.ps1`

Expected: FAIL with `Missing required file: about.html`.

- [ ] **Step 3: Commit the verification harness**

```powershell
git add tests/verify-site.ps1
git commit -m "test: add static site verification"
```

### Task 2: Build the Shared Visual and Interaction Foundation

**Files:**
- Create: `assets/css/styles.css`
- Create: `assets/js/site.js`

- [ ] **Step 1: Create the shared stylesheet**

Implement these concrete contracts in `assets/css/styles.css`:

```css
:root {
  --paper: #f3f0e7;
  --paper-bright: #fbfaf6;
  --ink: #16362f;
  --ink-soft: #47625b;
  --gold: #c7983d;
  --line: rgba(22, 54, 47, 0.18);
  --display: "Cormorant Garamond", Georgia, serif;
  --body: "IBM Plex Sans", "Noto Sans SC", sans-serif;
  --max: 1180px;
}
```

Define shared styles for `.site-header`, `.brand`, `.site-nav`, `.lang-switch`, `.menu-toggle`, `.page-shell`, `.eyebrow`, `.display-title`, `.hero`, `.button`, `.text-link`, `.section`, `.section-heading`, `.card`, `.timeline`, `.publication`, `.tag-list`, `.site-footer`, `.reveal`, and `.is-visible`. Include desktop editorial grids, a mobile breakpoint at `760px`, visible `:focus-visible` outlines, and `@media (prefers-reduced-motion: reduce)` that disables transitions and transforms.

- [ ] **Step 2: Create the shared JavaScript**

Implement `assets/js/site.js` with this interface and behavior:

```javascript
(() => {
  const storageKey = 'jiahui-site-language';
  const translated = document.querySelectorAll('[data-en][data-zh]');
  const switcher = document.querySelector('[data-language-toggle]');
  const menuButton = document.querySelector('[data-menu-toggle]');
  const navigation = document.querySelector('[data-navigation]');

  function setLanguage(language) {
    const next = language === 'zh' ? 'zh' : 'en';
    document.documentElement.lang = next === 'zh' ? 'zh-CN' : 'en';
    translated.forEach((node) => {
      node.textContent = node.dataset[next];
    });
    document.title = document.body.dataset[`title${next === 'zh' ? 'Zh' : 'En'}`];
    if (switcher) {
      switcher.textContent = next === 'zh' ? 'EN' : '中文';
      switcher.setAttribute('aria-label', next === 'zh' ? 'Switch to English' : '切换到中文');
    }
    localStorage.setItem(storageKey, next);
  }

  const saved = localStorage.getItem(storageKey) || 'en';
  setLanguage(saved);
  switcher?.addEventListener('click', () => setLanguage(document.documentElement.lang.startsWith('zh') ? 'en' : 'zh'));
  menuButton?.addEventListener('click', () => {
    const open = navigation.classList.toggle('is-open');
    menuButton.setAttribute('aria-expanded', String(open));
  });

  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => entry.isIntersecting && entry.target.classList.add('is-visible'));
  }, { threshold: 0.12 });
  document.querySelectorAll('.reveal').forEach((element) => observer.observe(element));
})();
```

Wrap `localStorage` access in `try/catch` so privacy-restricted browsers still work, and make reveal content visible when `IntersectionObserver` is unavailable.

- [ ] **Step 3: Inspect the foundation files for syntax and required selectors**

Run:

```powershell
Select-String -Path assets/css/styles.css -Pattern 'prefers-reduced-motion|focus-visible|@media.*760'
Select-String -Path assets/js/site.js -Pattern 'setLanguage|localStorage|IntersectionObserver|aria-expanded'
```

Expected: each command returns matches for every listed behavior.

- [ ] **Step 4: Commit the shared foundation**

```powershell
git add assets/css/styles.css assets/js/site.js
git commit -m "feat: add shared academic site design system"
```

### Task 3: Build the Home Page

**Files:**
- Modify: `index.html`
- Add: `Resume_Chenjiahui.pdf`

- [ ] **Step 1: Replace the placeholder with semantic home-page markup**

Create a complete HTML5 document with:

```html
<body data-title-en="Jiahui Chen | Energy & Environmental Economics"
      data-title-zh="陈嘉慧｜能源与环境经济学">
```

Add the shared header with Home/About/Research links, mobile control, and language button. The hero must identify Jiahui Chen as a doctoral student in Applied Economics at Beijing Institute of Technology and describe research in energy and environmental economics. Add links to `research.html`, `Resume_Chenjiahui.pdf`, the supplied Scholar URL, and the supplied ORCID URL. Add a featured publication card for:

```text
Liu, Y., Chen, J.*, Zhao, L., & Liao, H. (2023). Rural photovoltaic projects substantially prompt household energy transition: Evidence from China. Energy, 275, 127505.
```

Add bilingual research-theme labels for household energy transition, clean energy access, time use, and gender equality. Finish with a footer containing both resume email addresses and academic profile links.

- [ ] **Step 2: Validate home-page content**

Run:

```powershell
$home = Get-Content -Raw -Encoding UTF8 index.html
@('about.html','research.html','Resume_Chenjiahui.pdf','tpFVbtoAAAAJ','0000-0003-0874-3194','Energy, 275, 127505','data-en=','data-zh=') | ForEach-Object { if ($home -notmatch [regex]::Escape($_)) { throw "Missing: $_" } }
```

Expected: exits successfully with no output.

- [ ] **Step 3: Commit the home page and downloadable resume**

```powershell
git add index.html Resume_Chenjiahui.pdf
git commit -m "feat: build bilingual academic home page"
```

### Task 4: Build the About Page

**Files:**
- Create: `about.html`

- [ ] **Step 1: Add bilingual biography and education**

Use the shared header/footer contract and add an introduction derived only from the resume. Add an education timeline with Beijing Institute of Technology (doctoral student, Applied Economics, 2021–present) and Beijing Forestry University (Bachelor, Economics and Management of Agriculture and Forestry, 2017–2021; grade 98.55; rank 1/34).

- [ ] **Step 2: Add skills, service, and awards**

Add bilingual entries for Python, Stata, ArcGIS, Origin, SPSS, and EViews; three field investigations; 432.5 volunteer hours across more than 30 activities; and the five listed awards from 2018–2022. Do not publish gender, age, phone number, or street address.

- [ ] **Step 3: Validate About-page facts and privacy constraints**

Run:

```powershell
$about = Get-Content -Raw -Encoding UTF8 about.html
@('Beijing Institute of Technology','Beijing Forestry University','98.55','1/34','432.5','Python','data-en=','data-zh=') | ForEach-Object { if ($about -notmatch [regex]::Escape($_)) { throw "Missing: $_" } }
@('188-1178-7330','Female / 24','5 Zhongguancun South Street') | ForEach-Object { if ($about -match [regex]::Escape($_)) { throw "Private content exposed: $_" } }
```

Expected: exits successfully with no output.

- [ ] **Step 4: Commit the About page**

```powershell
git add about.html
git commit -m "feat: add bilingual about page"
```

### Task 5: Build the Research Page

**Files:**
- Create: `research.html`

- [ ] **Step 1: Add research themes and publication groups**

Use the shared header/footer contract. Add bilingual thematic introductions, then group entries under Peer-reviewed Publication, Working Papers, and Undergraduate Research. Include the complete *Energy* citation, both working-paper titles and author lists, and both 2019–2020 undergraduate research projects. Clearly label working papers and avoid presenting journal impact factor as a current metric.

- [ ] **Step 2: Add academic identity calls to action**

Add the supplied Google Scholar and ORCID links with `target="_blank" rel="noopener noreferrer"`, plus a CV download link.

- [ ] **Step 3: Validate research content and link safety**

Run:

```powershell
$research = Get-Content -Raw -Encoding UTF8 research.html
@('Rural photovoltaic projects','Household Energy Transition Improves','Cleaner Energy Access','forestland transfer','land property rights security','noopener noreferrer','tpFVbtoAAAAJ','0000-0003-0874-3194') | ForEach-Object { if ($research -notmatch [regex]::Escape($_)) { throw "Missing: $_" } }
```

Expected: exits successfully with no output.

- [ ] **Step 4: Commit the Research page**

```powershell
git add research.html
git commit -m "feat: add bilingual research page"
```

### Task 6: Run Automated and Browser Verification

**Files:**
- Modify if defects are found: `index.html`, `about.html`, `research.html`, `assets/css/styles.css`, `assets/js/site.js`, `tests/verify-site.ps1`

- [ ] **Step 1: Run the complete static verification**

Run: `powershell -ExecutionPolicy Bypass -File tests/verify-site.ps1`

Expected: `Site verification passed.`

- [ ] **Step 2: Start a local static server**

Run: `python -m http.server 8000`

Expected: server listens on `http://localhost:8000` without errors.

- [ ] **Step 3: Verify the desktop experience in a browser**

Open `http://localhost:8000`. Confirm the hero hierarchy, featured publication, navigation to all three pages, CV download, and Scholar/ORCID destinations. Switch to Chinese, navigate between pages, and confirm the selection persists and page titles change.

- [ ] **Step 4: Verify mobile and accessibility behavior**

At a viewport near 390 × 844, confirm the menu opens and closes, no horizontal overflow occurs, text remains readable, focus states are visible, and content remains visible with reduced motion enabled.

- [ ] **Step 5: Run final repository checks**

Run:

```powershell
git diff --check
git status --short
```

Expected: no whitespace errors; only intentional implementation files are staged or modified.

- [ ] **Step 6: Commit verification fixes if needed**

```powershell
git add index.html about.html research.html assets/css/styles.css assets/js/site.js tests/verify-site.ps1
git commit -m "fix: polish responsive and bilingual site behavior"
```
