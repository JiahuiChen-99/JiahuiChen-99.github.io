# Home and About Single-Page Consolidation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Consolidate the profile content from `about.html` into `index.html`, remove About from navigation, and delete `about.html`.

**Architecture:** Keep the site as static bilingual HTML. Reuse the existing `plain-section` and `dated-list` components, make `index.html` the sole profile page, retain `research.html` as the publications page, and update the verification script to enforce the new two-page architecture.

**Tech Stack:** HTML5, vanilla JavaScript data attributes, CSS, PowerShell verification, Playwright

---

### Task 1: Define the two-page architecture in regression tests

**Files:**
- Modify: `tests/verify-site.ps1`
- Test: `tests/verify-site.ps1`

- [ ] **Step 1: Remove `about.html` from required files and page arrays**

Use:

```powershell
$requiredFiles = @(
    'index.html'
    'research.html'
    'assets/css/styles.css'
    'assets/js/site.js'
    'assets/images/jiahui-chen.jpg'
    'Resume_Chenjiahui.pdf'
)

$htmlPages = @('index.html', 'research.html')
$requiredPageLinks = @('index.html', 'research.html')
```

- [ ] **Step 2: Add single-page profile assertions after `$homeHtml` is assigned**

```powershell
$aboutPath = Join-Path $siteRoot 'about.html'
if (Test-Path -LiteralPath $aboutPath) {
    throw 'Standalone about.html must be removed after profile consolidation'
}

if ($allHtml.Contains('about.html')) {
    throw 'Site navigation must not link to removed about.html'
}

$requiredMergedSections = @(
    'id="education-title"'
    'id="upcoming-title"'
    'id="honors-title"'
    'id="service-title"'
    'China Scholarship Council Scholarship'
    'Reviewer for the AERE Summer Conference'
)
foreach ($section in $requiredMergedSections) {
    if (-not $homeHtml.Contains($section)) {
        throw "Homepage is missing merged About content: $section"
    }
}
```

- [ ] **Step 3: Run the verification script and confirm it fails**

Run: `powershell -ExecutionPolicy Bypass -File tests/verify-site.ps1`

Expected: FAIL with `Standalone about.html must be removed after profile consolidation`.

- [ ] **Step 4: Commit the failing regression test**

```powershell
git add -- tests/verify-site.ps1
git commit -m "test: define consolidated profile architecture"
```

### Task 2: Consolidate About content into the homepage

**Files:**
- Modify: `index.html`
- Test: `tests/verify-site.ps1`

- [ ] **Step 1: Remove the About navigation link from the homepage header**

Use this navigation content:

```html
<nav class="site-nav" data-navigation aria-label="Primary navigation" data-aria-en="Primary navigation" data-aria-zh="主要导航"><a href="index.html" aria-current="page" data-en="Home" data-zh="首页">Home</a><a href="research.html" data-en="Research" data-zh="研究">Research</a></nav>
```

- [ ] **Step 2: Replace the compact Education list with detailed dated entries**

```html
<section class="plain-section" aria-labelledby="education-title">
  <h2 id="education-title" data-en="Education" data-zh="教育背景">Education</h2>
  <ul class="dated-list">
    <li><time>2021–<span data-en="present" data-zh="至今">present</span></time><div><strong data-en="Beijing Institute of Technology" data-zh="北京理工大学">Beijing Institute of Technology</strong><p data-en="PhD candidate in Energy and Climate Economics, School of Management. Supervisor: Professor Hua Liao." data-zh="管理学院能源与气候经济方向经济学博士研究生（硕博连读）。导师：廖华教授。">PhD candidate in Energy and Climate Economics, School of Management. Supervisor: Professor Hua Liao.</p></div></li>
    <li><time>2024–2026</time><div><strong data-en="Duke University" data-zh="美国杜克大学">Duke University</strong><p data-en="Joint doctoral training in Energy and Environmental Economics, Sanford School of Public Policy." data-zh="Sanford 公共政策学院能源与环境经济方向联合培养博士。">Joint doctoral training in Energy and Environmental Economics, Sanford School of Public Policy.</p></div></li>
    <li><time>2017–2021</time><div><strong data-en="Beijing Forestry University" data-zh="北京林业大学">Beijing Forestry University</strong><p data-en="Bachelor of Management in Agricultural and Forestry Economics and Management. Ranked 1/34 (top 3%)." data-zh="经济管理学院农林经济管理专业管理学学士，专业排名 1/34（前 3%）。">Bachelor of Management in Agricultural and Forestry Economics and Management. Ranked 1/34 (top 3%).</p></div></li>
  </ul>
</section>
```

- [ ] **Step 3: Add Selected honors after Upcoming presentations and trips**

```html
<section class="plain-section" aria-labelledby="honors-title">
  <h2 id="honors-title" data-en="Selected honors" data-zh="代表性荣誉">Selected honors</h2>
  <ul class="dated-list compact">
    <li><time>2026</time><div data-en="Excellent Doctoral Dissertation Incubation Fund, Beijing Institute of Technology" data-zh="北京理工大学优秀博士学位论文育苗基金">Excellent Doctoral Dissertation Incubation Fund, Beijing Institute of Technology</div></li>
    <li><time>2025</time><div data-en="Outstanding Student, Beijing Institute of Technology" data-zh="北京理工大学优秀学生">Outstanding Student, Beijing Institute of Technology</div></li>
    <li><time>2024–2026</time><div data-en="China Scholarship Council Scholarship" data-zh="国家留学基金委公派奖学金">China Scholarship Council Scholarship</div></li>
    <li><time>2022, 2026</time><div data-en="First Prize for Academic Achievement, BIT CEEP Young Scholars Seminar" data-zh="北京理工大学 CEEP 青年学者研讨会学术成果一等奖（两次）">First Prize for Academic Achievement, BIT CEEP Young Scholars Seminar</div></li>
    <li><time>2023</time><div data-en="First Prize for Outstanding Presentation, Symposium on Household Carbon Emissions and Sustainable Consumption" data-zh="生活碳排放和可持续消费研讨会优秀交流报告一等奖">First Prize for Outstanding Presentation, Symposium on Household Carbon Emissions and Sustainable Consumption</div></li>
  </ul>
</section>
```

- [ ] **Step 4: Add Academic service after Selected honors**

```html
<section class="plain-section" aria-labelledby="service-title">
  <h2 id="service-title" data-en="Academic service" data-zh="学术服务">Academic service</h2>
  <p data-en="Reviewer for the AERE Summer Conference (2025), Energy Policy, Energy Economics, Energy, World Development, Humanities and Social Sciences Communications, and Environmental Science and Pollution Research." data-zh="担任 AERE Summer Conference（2025）、Energy Policy、Energy Economics、Energy、World Development、Humanities and Social Sciences Communications、Environmental Science and Pollution Research 等匿名审稿人。">Reviewer for the AERE Summer Conference (2025), Energy Policy, Energy Economics, Energy, World Development, Humanities and Social Sciences Communications, and Environmental Science and Pollution Research.</p>
</section>
```

### Task 3: Remove the standalone About page and its remaining navigation link

**Files:**
- Modify: `research.html`
- Delete: `about.html`
- Test: `tests/verify-site.ps1`

- [ ] **Step 1: Remove the About navigation link from `research.html`**

Use this navigation content:

```html
<nav class="site-nav" data-navigation aria-label="Primary navigation" data-aria-en="Primary navigation" data-aria-zh="主要导航"><a href="index.html" data-en="Home" data-zh="首页">Home</a><a href="research.html" aria-current="page" data-en="Research" data-zh="研究">Research</a></nav>
```

- [ ] **Step 2: Delete `about.html`**

Delete only the tracked file `about.html`.

- [ ] **Step 3: Run automated verification**

Run: `powershell -ExecutionPolicy Bypass -File tests/verify-site.ps1`

Expected: `Site verification passed.`

- [ ] **Step 4: Check the implementation diff**

Run: `git diff --check -- index.html research.html about.html tests/verify-site.ps1` and `git diff --stat`.

Expected: no whitespace errors; changes are limited to the four planned implementation files.

- [ ] **Step 5: Commit the consolidation**

```powershell
git add -- index.html research.html about.html
git commit -m "feat: consolidate profile into homepage"
```

### Task 4: Verify, integrate, and publish

**Files:**
- Verify: `index.html`
- Verify: `research.html`
- Verify: `tests/verify-site.ps1`

- [ ] **Step 1: Run browser verification at 1440px and 390px**

Confirm Home and Research navigation, all five homepage sections, bilingual switching, no About link, no console errors, and no horizontal overflow.

- [ ] **Step 2: Merge the tested feature branch into `main`**

Run: `git merge --ff-only feat/home-about-single-page`.

Expected: a fast-forward merge.

- [ ] **Step 3: Run final verification on `main`**

Run: `powershell -ExecutionPolicy Bypass -File tests/verify-site.ps1`.

Expected: `Site verification passed.`

- [ ] **Step 4: Push `main` and verify deployment**

Run: `git push origin main`, then fetch `https://jiahuichen-99.github.io/index.html` without cache.

Expected: the deployed homepage contains Selected honors and Academic service, and contains no `about.html` navigation link.
