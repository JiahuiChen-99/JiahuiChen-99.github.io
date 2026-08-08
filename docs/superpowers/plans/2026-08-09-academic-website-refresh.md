# Friendly Bilingual Academic Website Refresh Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refresh Jiahui Chen’s three-page bilingual academic website with the corrected Chinese name 陈佳慧, current BIT/Duke affiliations, all formally published work from the new Word CV, a user-provided portrait, and a friendlier visual direction.

**Architecture:** Preserve the framework-free GitHub Pages architecture: three semantic HTML files share one stylesheet and one progressive-enhancement script. Update the static verification harness first, add an optimized portrait asset, then revise shared design and page content before running full Playwright verification and pushing `main`.

**Tech Stack:** HTML5, CSS3, vanilla JavaScript, PowerShell verification, Python Playwright, GitHub Pages.

---

## File Structure

- `index.html`: friendly portrait-led Home page, dual current affiliations, research focus, and recent publications.
- `about.html`: biography, BIT/Duke/BFU education timeline, research interests, and selected honors.
- `research.html`: exactly seven formally published papers plus representative projects.
- `assets/css/styles.css`: friendly green/ivory design system, responsive portrait layouts, publication lists, and accessibility states.
- `assets/js/site.js`: existing bilingual, mobile-navigation, title, ARIA, and reveal behavior; change only if the refreshed markup requires it.
- `assets/images/jiahui-chen.jpg`: compressed/cropped user-provided portrait without generative alteration.
- `tests/verify-site.ps1`: refreshed factual, privacy, publication-scope, image, and link assertions.
- `Resume_Chenjiahui.pdf`: retained unchanged as the public CV target.

### Task 1: Strengthen the Refresh Verification Contract

**Files:**
- Modify: `tests/verify-site.ps1`

- [ ] **Step 1: Add failing refresh assertions**

Extend the verifier after existing structural checks with these exact contracts:

```powershell
$allVisible = ($cleanPages.Values -join "`n")
$requiredFacts = @(
  '陈佳慧',
  'chenjh99@bit.edu.cn',
  'Duke University',
  'Sanford School of Public Policy',
  'assets/images/jiahui-chen.jpg'
)
foreach ($fact in $requiredFacts) {
  if (-not $allVisible.Contains($fact)) { throw "Missing refreshed fact: $fact" }
}

$forbiddenFacts = @(
  '陈嘉慧', 'Jiahui.chen@duke.edu', '3120225853@bit.edu.cn',
  'chenjiahuicjf@163.com', '188-1178-7330',
  '5 Zhongguancun South Street', 'Working paper', 'Under Review', 'Minor revision'
)
foreach ($fact in $forbiddenFacts) {
  if ($allVisible.Contains($fact)) { throw "Forbidden public content found: $fact" }
}

$research = $cleanPages['research.html']
$publishedTitles = @(
  'Global public perceptions of climate change risks and their determinants',
  'Empowering women substantially accelerates the household clean energy transition in China',
  'Rural photovoltaic projects substantially prompt household energy transition',
  'Household Energy Transition Improves Children’s Participation in Extracurricular Intellectual Activities',
  'Weather, Travel Modes, and the Effectiveness of Driving Restriction Policies',
  'Decoupling carbon emissions, economic growth, and health costs toward carbon neutrality',
  'Public pension accelerates the household electrification'
)
foreach ($title in $publishedTitles) {
  if (-not $research.Contains($title)) { throw "Missing published title: $title" }
}
```

Require `assets/images/jiahui-chen.jpg` in the required-file list and require `Resume_Chenjiahui.pdf` to remain an actual `href`.

- [ ] **Step 2: Run the verifier and confirm the old site fails**

Run: `powershell -ExecutionPolicy Bypass -File tests/verify-site.ps1`

Expected: FAIL on a refreshed fact such as `陈佳慧` or the portrait asset.

- [ ] **Step 3: Commit the red verification contract**

```powershell
git add tests/verify-site.ps1
git commit -m "test: define academic site refresh contract"
```

### Task 2: Prepare the User Portrait

**Files:**
- Create: `assets/images/jiahui-chen.jpg`

- [ ] **Step 1: Inspect and prepare the supplied photo**

Use the user-provided conversation image as the sole source. Preserve identity and appearance. Produce a high-quality sRGB JPEG near 1200 × 1400 pixels, portrait-oriented, with the face and shoulders retained and the natural green background preserved. Do not synthesize, retouch facial features, replace the background, or add graphical elements.

- [ ] **Step 2: Validate the image asset**

Run:

```powershell
@'
from PIL import Image
p = 'assets/images/jiahui-chen.jpg'
with Image.open(p) as im:
    assert im.format == 'JPEG'
    assert im.width >= 800 and im.height >= 900
    assert im.height > im.width
    assert im.mode in ('RGB', 'L')
    print(f'Portrait OK: {im.width}x{im.height}, {im.mode}')
'@ | python -
```

Expected: `Portrait OK:` followed by valid dimensions and `RGB`.

- [ ] **Step 3: Commit the portrait**

```powershell
git add assets/images/jiahui-chen.jpg
git commit -m "feat: add Jiahui Chen portrait"
```

### Task 3: Refresh the Shared Friendly Visual System

**Files:**
- Modify: `assets/css/styles.css`
- Modify only if needed: `assets/js/site.js`

- [ ] **Step 1: Implement the friendly visual direction**

Keep deep green/ivory accessibility-safe tokens but replace institutional density with a lighter system. Add complete styles for:

```css
.friendly-hero { display: grid; grid-template-columns: minmax(220px, .72fr) 1.45fr; gap: clamp(2rem, 6vw, 6rem); align-items: center; }
.portrait-frame { position: relative; max-width: 340px; margin-inline: auto; }
.portrait-frame img { width: 100%; aspect-ratio: 4 / 5; object-fit: cover; object-position: center 36%; border-radius: 50% 50% 46% 46% / 42% 42% 58% 58%; }
.hello { font-family: var(--body); color: var(--green-mid); font-size: clamp(1rem, 2vw, 1.35rem); }
.identity-lines, .interest-pills, .publication-list, .project-list { display: grid; gap: 1rem; }
```

Use softer cards, lower shadow intensity, fewer borders, and approachable spacing. Maintain visible focus, no-JS visibility, reduced-motion overrides, the 760px mobile menu, and a single-column portrait-first mobile hero. Add stable image-failure layout and print-friendly behavior.

- [ ] **Step 2: Confirm progressive enhancement and responsive contracts**

Run:

```powershell
Select-String assets/css/styles.css -Pattern 'friendly-hero|portrait-frame|object-position|prefers-reduced-motion|focus-visible|@media.*760'
Select-String assets/js/site.js -Pattern 'setLanguage|data-aria|aria-expanded|focus'
```

Expected: matches for every listed visual and interaction requirement.

- [ ] **Step 3: Commit the shared refresh**

```powershell
git add assets/css/styles.css assets/js/site.js
git commit -m "feat: adopt friendly personal site design"
```

### Task 4: Refresh Home and About Content

**Files:**
- Modify: `index.html`
- Modify: `about.html`

- [ ] **Step 1: Rebuild Home with the friendly portrait-led opening**

Use `assets/images/jiahui-chen.jpg` with bilingual alt meaning “Portrait of Jiahui Chen / 陈佳慧肖像”. Add “Hi, I’m Jiahui 👋” / “你好，我是佳慧 👋”, corrected Chinese name, BIT doctoral role (2022–2027), Duke Sanford joint doctoral training (2024–2026), and three research themes. Keep Research, Scholar, ORCID, PDF, and `mailto:chenjh99@bit.edu.cn`; remove both old emails and the Duke email. Add a small recent-publications area using formally published papers only.

- [ ] **Step 2: Rebuild About from the new Word CV**

Add the four confirmed education entries, UNEP/EDP exchange note, research direction, and selected current-stage honors. Use short first-person bilingual prose. Exclude gender, age, phone, address, political affiliation, hometown, supervisor honorifics, and administrative student roles.

- [ ] **Step 3: Validate Home and About facts**

Run:

```powershell
$pages = (Get-Content -Raw -Encoding UTF8 index.html) + (Get-Content -Raw -Encoding UTF8 about.html)
@('陈佳慧','chenjh99@bit.edu.cn','Duke University','Sanford School of Public Policy','2024–2026','assets/images/jiahui-chen.jpg') | ForEach-Object { if (-not $pages.Contains($_)) { throw "Missing: $_" } }
@('陈嘉慧','Jiahui.chen@duke.edu','3120225853@bit.edu.cn','chenjiahuicjf@163.com','188-1178-7330') | ForEach-Object { if ($pages.Contains($_)) { throw "Forbidden: $_" } }
```

Expected: exits successfully with no output.

- [ ] **Step 4: Commit Home and About**

```powershell
git add index.html about.html
git commit -m "feat: refresh bilingual home and about pages"
```

### Task 5: Publish the Formal Research Record

**Files:**
- Modify: `research.html`

- [ ] **Step 1: Replace the old research list**

Create a bilingual introduction and a year-descending publication list containing exactly the seven formally published works enumerated in the design specification. Preserve official English citations, mark Chen, J. visually without changing author order, and omit IF/quartile claims, DOI guesses, minor revisions, under-review manuscripts, and working papers.

- [ ] **Step 2: Add representative projects**

Add a compact bilingual section for the hosted BIT project “Employment Impacts and Vulnerability Assessment in the Energy Transition” (2024YCXY060, 2024–2025) and a small number of closely related national projects. Clearly distinguish “Principal Investigator” from “Participant”.

- [ ] **Step 3: Run the full static verifier**

Run: `powershell -ExecutionPolicy Bypass -File tests/verify-site.ps1`

Expected: `Site verification passed.`

- [ ] **Step 4: Commit Research**

```powershell
git add research.html
git commit -m "feat: update published research record"
```

### Task 6: Browser Verification, Integration, and Deployment

**Files:**
- Modify only if defects are found: `index.html`, `about.html`, `research.html`, `assets/css/styles.css`, `assets/js/site.js`, `tests/verify-site.ps1`, `assets/images/jiahui-chen.jpg`

- [ ] **Step 1: Run static and repository checks**

```powershell
powershell -ExecutionPolicy Bypass -File tests/verify-site.ps1
git diff --check
git status --short --branch
```

Expected: site verification passes, no whitespace errors, and no unintended files are tracked.

- [ ] **Step 2: Run Playwright desktop and mobile checks**

Start a temporary local server and verify all three pages at desktop and 390 × 844. Assert no horizontal overflow, portrait load and natural dimensions, exactly seven research publications, language switch/title/ARIA persistence, internal navigation, exact Scholar/ORCID/PDF/email links, mobile keyboard focus sequence, Escape focus return, reduced-motion visibility, and zero console/page errors.

- [ ] **Step 3: Visually inspect screenshots**

Inspect full-page English/Chinese desktop Home and mobile Home screenshots. Confirm the face is not cut off, the green background harmonizes with the page palette, the friendly opening is clear, and publication lists remain scannable.

- [ ] **Step 4: Commit any verification fixes**

```powershell
git add index.html about.html research.html assets/css/styles.css assets/js/site.js tests/verify-site.ps1 assets/images/jiahui-chen.jpg
git commit -m "fix: polish refreshed academic website"
```

Skip this commit if no files changed.

- [ ] **Step 5: Merge and verify `main`**

Fast-forward the isolated feature branch into `main`, rerun the static verifier and Playwright suite from the main worktree, then remove the owned worktree and feature branch only after successful verification.

- [ ] **Step 6: Push to GitHub through the available local proxy**

Run:

```powershell
git -c http.proxy=http://127.0.0.1:7890 push origin main
```

Expected: remote `main` advances to the local verified commit. Then confirm `git ls-remote origin refs/heads/main` matches local `git rev-parse HEAD` and verify `https://jiahuichen-99.github.io/` after GitHub Pages finishes deploying.
