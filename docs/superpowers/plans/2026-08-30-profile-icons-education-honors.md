# Profile Icons, Education, and Honors Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refine the portrait contact block with reference-style SVG icons and single-line institution text, add Alex Pfaff supervision details, and update Selected honors.

**Architecture:** Keep the existing portrait panel and bilingual static HTML, replacing character icons with accessible inline SVG. Widen the reserved portrait column without changing the site’s overall visual system, and split the Duke description into bilingual fragments so the supervisor name remains a live link after language switching.

**Tech Stack:** HTML5, inline SVG, CSS, vanilla JavaScript data attributes, PowerShell verification, Playwright

---

### Task 1: Add regression checks

**Files:**
- Modify: `tests/verify-site.ps1`
- Test: `tests/verify-site.ps1`

- [ ] **Step 1: Add required homepage markers**

Add these strings to `$requiredHomeContent`:

```powershell
'class="portrait-meta-icon portrait-meta-icon-building"'
'class="portrait-meta-icon portrait-meta-icon-email"'
'class="portrait-meta-icon portrait-meta-icon-linkedin"'
'class="portrait-meta-institution"'
'https://sanford.duke.edu/profile/alexander-pfaff/'
'Supervisor: Professor Alex Pfaff.'
'China Scholarship Council (CSC) Scholarship'
'National Scholarship, Ministry of Education of China'
'2023, 2026'
```

- [ ] **Step 2: Add stale-content checks**

Add `'<span class="portrait-meta-icon" aria-hidden="true">▦</span>'`, `'<span class="portrait-meta-icon" aria-hidden="true">✉</span>'`, `'>in</span><a href="https://www.linkedin.com/'`, `'2022, 2026'`, and `'China Scholarship Council Scholarship'` to `$forbiddenUpdatedHomeContent`.

- [ ] **Step 3: Run verification and confirm failure**

Run: `powershell -ExecutionPolicy Bypass -File tests/verify-site.ps1`

Expected: FAIL because the new SVG building icon marker is absent.

- [ ] **Step 4: Commit the failing checks**

```powershell
git add -- tests/verify-site.ps1
git commit -m "test: cover profile icons and honors updates"
```

### Task 2: Replace contact icons and update content

**Files:**
- Modify: `index.html`
- Test: `tests/verify-site.ps1`

- [ ] **Step 1: Replace the three character icons with inline SVG**

Use `viewBox="0 0 24 24"`, `aria-hidden="true"`, and these classes:

```html
<svg class="portrait-meta-icon portrait-meta-icon-building" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 2 2 7v2h20V7L12 2ZM5 11v7H3v2h18v-2h-2v-7h-2v7h-3v-7h-2v7H9v-7H7v7H5v-7Z"/></svg>
<svg class="portrait-meta-icon portrait-meta-icon-email" viewBox="0 0 24 24" aria-hidden="true"><path d="M3 5h18a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2Zm9 7.1L20.2 7H3.8l8.2 5.1ZM3 17h18V9.3l-9 5.6-9-5.6V17Z"/></svg>
<svg class="portrait-meta-icon portrait-meta-icon-linkedin" viewBox="0 0 24 24" aria-hidden="true"><rect x="2" y="2" width="20" height="20" rx="1"/><circle cx="7.2" cy="8" r="1.3"/><path d="M6 10.2h2.4V18H6v-7.8Zm4 0h2.3v1.1h.1c.3-.6 1.1-1.4 2.8-1.4 3 0 3.6 2 3.6 4.5V18h-2.4v-3.2c0-.8 0-2.7-1.7-2.7s-1.9 1.3-1.9 2.6V18H10v-7.8Z"/></svg>
```

The LinkedIn icon uses CSS to render the square blue and its circle/path details white; no separate `in` text remains.

- [ ] **Step 2: Mark the institution text and update Duke supervision**

Add `class="portrait-meta-institution"` to the Beijing Institute of Technology label.

Render the Duke text with bilingual spans and this linked name:

```html
<a href="https://sanford.duke.edu/profile/alexander-pfaff/" target="_blank" rel="noopener noreferrer" data-en="Professor Alex Pfaff" data-zh="Alex Pfaff 教授">Professor Alex Pfaff</a>
```

- [ ] **Step 3: Update Selected honors**

Use `China Scholarship Council (CSC) Scholarship`, change the award time to `<time>2023, 2026</time>`, and append:

```html
<li><time>2020</time><div data-en="National Scholarship, Ministry of Education of China" data-zh="国家奖学金，教育部">National Scholarship, Ministry of Education of China</div></li>
```

### Task 3: Refine responsive panel styles

**Files:**
- Modify: `assets/css/styles.css`
- Test: `tests/verify-site.ps1`

- [ ] **Step 1: Widen the portrait column**

Set `.profile-copy { padding-right: 18.5rem; }` and `.portrait-panel { width: 16.5rem; }`. Keep `.portrait-frame` at `12.5rem`.

- [ ] **Step 2: Style inline SVG and prevent institution wrapping**

```css
.portrait-meta-institution { white-space: nowrap; }
.portrait-meta-icon { width: 1rem; height: 1rem; color: var(--ink); fill: currentColor; }
.portrait-meta-icon-linkedin { color: #0a66c2; }
.portrait-meta-icon-linkedin circle, .portrait-meta-icon-linkedin path { fill: #fff; }
```

Retain the mobile panel width `min(100%, 18rem)` so the institution remains single-line without horizontal overflow.

- [ ] **Step 3: Run automated verification and commit**

Run: `powershell -ExecutionPolicy Bypass -File tests/verify-site.ps1`

Expected: `Site verification passed.`

Commit:

```powershell
git add -- index.html assets/css/styles.css
git commit -m "feat: refine profile icons and honors"
```

### Task 4: Browser verification and deployment

**Files:**
- Verify: `index.html`
- Verify: `assets/css/styles.css`

- [ ] **Step 1: Verify desktop and mobile rendering**

At 1440px, 390px, and 320px, assert the institution label has one line, the metadata begins directly below the portrait, no standalone `in` text exists, Alex Pfaff’s link works, all honors render in order, bilingual switching works, and there is no overflow or overlap.

- [ ] **Step 2: Merge, verify, and push**

Fast-forward merge `feat/profile-icons-education-honors` into `main`, run the site verification script, and push `main`.

- [ ] **Step 3: Verify deployed HTML**

Fetch the homepage without cache and confirm SVG icon classes, Alex Pfaff link, CSC wording, 2020 national scholarship, and `2023, 2026` are present.
