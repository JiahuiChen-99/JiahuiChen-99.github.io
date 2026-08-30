# Profile Details and Publication Metadata Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refine homepage profile content and portrait metadata, update Education and Academic service, add a last-updated footer, and correct three publication records.

**Architecture:** Preserve the static bilingual site and existing page components. Introduce one responsive `.portrait-panel` containing the existing portrait plus an accessible metadata list, use bilingual text fragments around linked and emphasized content, and strengthen the PowerShell regression test before changing production HTML/CSS.

**Tech Stack:** HTML5, CSS, inline SVG, vanilla JavaScript data attributes, PowerShell verification, Playwright

---

### Task 1: Add regression checks for approved content

**Files:**
- Modify: `tests/verify-site.ps1`
- Test: `tests/verify-site.ps1`

- [ ] **Step 1: Replace the obsolete homepage research marker and add new required facts**

In `$requiredHomeContent`, replace `'household energy transitions'` with these exact markers:

```powershell
'I am a PhD candidate at the Center for Energy and Environmental Policy Research (CEEP), Beijing Institute of Technology (BIT) since 2021'
'energy transitions and climate change'
'class="portrait-meta"'
'She/Her'
'https://www.linkedin.com/in/jiahui-chen-193418387/'
'Site last updated 2026-8-28'
'Visiting PhD student in Energy and Environmental Economics'
'Sustainable Development'
'Energy, Sustainability and Society'
'Clean Energy Science and Technology'
```

Add `https://scholar.google.com/citations?user=-TFrj1UAAAAJ&amp;hl=en&amp;oi=ao` to the same list.

- [ ] **Step 2: Add forbidden stale homepage markers**

```powershell
$forbiddenUpdatedHomeContent = @(
    'I have been a PhD candidate'
    'household energy transitions'
    'Joint doctoral training in Energy and Environmental Economics'
    'Energy Economics, Energy, World Development'
)
foreach ($content in $forbiddenUpdatedHomeContent) {
    if ($homeHtml.Contains($content)) {
        throw "Homepage still contains superseded content: $content"
    }
}
```

- [ ] **Step 3: Add publication metadata assertions after `$researchHtml` is assigned**

```powershell
$requiredPublicationMetadata = @(
    '<i>Environment and Development Economics</i>, 2026, 1–23.'
    '<i>International Journal of Educational Development</i>, 120, 103486.'
    '<i>Transportation</i>, 1–26.'
)
foreach ($metadata in $requiredPublicationMetadata) {
    if (-not $researchHtml.Contains($metadata)) {
        throw "Research page is missing publication metadata: $metadata"
    }
}
```

- [ ] **Step 4: Run the test and confirm failure**

Run: `powershell -ExecutionPolicy Bypass -File tests/verify-site.ps1`

Expected: FAIL because the approved PhD-candidate sentence is not yet present.

- [ ] **Step 5: Commit the failing checks**

```powershell
git add -- tests/verify-site.ps1
git commit -m "test: cover profile details and publication metadata"
```

### Task 2: Update homepage content and portrait metadata

**Files:**
- Modify: `index.html`
- Test: `tests/verify-site.ps1`

- [ ] **Step 1: Wrap the portrait in `.portrait-panel` and add `.portrait-meta`**

The panel contains the existing `<figure>` followed by:

```html
<aside class="portrait-meta" aria-label="Jiahui Chen contact information" data-aria-en="Jiahui Chen contact information" data-aria-zh="陈佳慧联系信息">
  <strong class="portrait-meta-name" data-en="Jiahui Chen" data-zh="陈佳慧">Jiahui Chen</strong>
  <span class="portrait-pronouns" data-en="She/Her" data-zh="她/她">She/Her</span>
  <ul>
    <li><span class="portrait-meta-icon" aria-hidden="true">▦</span><span data-en="Beijing Institute of Technology" data-zh="北京理工大学">Beijing Institute of Technology</span></li>
    <li><span class="portrait-meta-icon" aria-hidden="true">✉</span><a href="mailto:chenjh99@bit.edu.cn">Email</a></li>
    <li><span class="portrait-meta-icon portrait-meta-icon-linkedin" aria-hidden="true">in</span><a href="https://www.linkedin.com/in/jiahui-chen-193418387/" target="_blank" rel="noopener noreferrer">LinkedIn</a></li>
  </ul>
</aside>
```

- [ ] **Step 2: Rebuild the first biography paragraph with a linked supervisor**

Use bilingual spans around this link:

```html
<a href="https://scholar.google.com/citations?user=-TFrj1UAAAAJ&amp;hl=en&amp;oi=ao" target="_blank" rel="noopener noreferrer" data-en="Professor Hua Liao" data-zh="廖华教授">Professor Hua Liao</a>
```

The rendered English sentence must read: `Welcome to my website! I am Jiahui Chen. I am a PhD candidate at the Center for Energy and Environmental Policy Research (CEEP), Beijing Institute of Technology (BIT) since 2021, under the supervision of Professor Hua Liao.`

- [ ] **Step 3: Emphasize the revised research phrase**

Use `<strong data-en="energy transitions and climate change" data-zh="能源转型与气候变化">energy transitions and climate change</strong>` and preserve the rest of the approved sentence.

- [ ] **Step 4: Update Education and Academic service**

Use `Visiting PhD student in Energy and Environmental Economics, Sanford School of Public Policy.` / `Sanford 公共政策学院能源与环境经济方向访问博士生。`

Use this English service text:

```text
Reviewer for the AERE Summer Conference (2025); Energy Policy; Humanities and Social Sciences Communications; Environmental Science and Pollution Research; Sustainable Development; Energy, Sustainability and Society; and Clean Energy Science and Technology.
```

- [ ] **Step 5: Add the homepage footer update date**

Add `<span data-en="Site last updated 2026-8-28" data-zh="网站最后更新于 2026-8-28">Site last updated 2026-8-28</span>` between the copyright and email.

### Task 3: Style the responsive portrait panel

**Files:**
- Modify: `assets/css/styles.css`
- Test: `tests/verify-site.ps1`

- [ ] **Step 1: Move absolute positioning from `.portrait-frame` to `.portrait-panel`**

```css
.portrait-panel { position: absolute; top: 7.9rem; right: .25rem; width: 12.5rem; }
.portrait-frame { width: 12.5rem; aspect-ratio: 1 / 1; margin: 0 0 1.1rem; }
```

- [ ] **Step 2: Add restrained metadata styles**

```css
.portrait-meta { display: grid; gap: .4rem; color: var(--muted); font-size: .86rem; line-height: 1.35; }
.portrait-meta-name { color: var(--ink); font-size: 1rem; font-weight: 600; }
.portrait-pronouns { margin-bottom: .35rem; }
.portrait-meta ul { display: grid; gap: .55rem; margin: 0; padding: 0; list-style: none; }
.portrait-meta li { display: grid; grid-template-columns: 1.1rem 1fr; gap: .5rem; align-items: start; }
.portrait-meta-icon { color: var(--ink); font-size: .9rem; line-height: 1.35; text-align: center; }
.portrait-meta-icon-linkedin { color: var(--accent); font-size: .72rem; font-weight: 700; }
.portrait-meta a { text-decoration: none; }
```

- [ ] **Step 3: Update mobile layout**

```css
.portrait-panel { position: static; order: 2; width: min(100%, 18rem); margin: 0 0 1.5rem; }
.portrait-frame { width: 9.5rem; }
```

### Task 4: Update three publication records

**Files:**
- Modify: `research.html`
- Test: `tests/verify-site.ps1`

- [ ] **Step 1: Apply the approved metadata**

Use `<i>Environment and Development Economics</i>, 2026, 1–23.`, `<i>International Journal of Educational Development</i>, 120, 103486.`, and `<i>Transportation</i>, 1–26.` while preserving author emphasis, titles, years, and the first paper DOI link.

- [ ] **Step 2: Run automated verification**

Run: `powershell -ExecutionPolicy Bypass -File tests/verify-site.ps1`

Expected: `Site verification passed.`

- [ ] **Step 3: Commit implementation**

```powershell
git add -- index.html research.html assets/css/styles.css
git commit -m "feat: enrich profile details and publication records"
```

### Task 5: Browser verification and deployment

**Files:**
- Verify: `index.html`
- Verify: `research.html`

- [ ] **Step 1: Verify at 1440px and 390px**

Assert correct English and Chinese biography text, supervisor link, portrait metadata order, email and LinkedIn links, bold research phrase, updated Education/service/footer, all three publication metadata strings, no console errors, and no horizontal overflow.

- [ ] **Step 2: Merge into `main` and verify**

Run `git merge --ff-only feat/profile-details-publications`, then `powershell -ExecutionPolicy Bypass -File tests/verify-site.ps1`.

- [ ] **Step 3: Push and verify GitHub Pages**

Run `git push origin main`, then fetch both deployed pages without cache and assert the new profile markers and publication metadata are present.
