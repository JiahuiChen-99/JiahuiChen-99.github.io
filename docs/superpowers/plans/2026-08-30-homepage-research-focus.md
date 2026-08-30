# Homepage Research Focus Update Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the homepage research-focus sentence with the author-approved English wording and its matching Chinese translation.

**Architecture:** Preserve the existing static HTML and bilingual `data-en`/`data-zh` fragment mechanism. Update the content regression check first, then change only the research-focus paragraph in `index.html`, verify rendered bilingual text, and publish the tested `main` branch.

**Tech Stack:** HTML5, vanilla JavaScript data attributes, PowerShell verification, Playwright

---

### Task 1: Update the homepage research-focus regression check

**Files:**
- Modify: `tests/verify-site.ps1`
- Test: `tests/verify-site.ps1`

- [ ] **Step 1: Replace the obsolete research-focus marker**

In `$requiredHomeContent`, replace:

```powershell
'empirical research about household energy transitions'
```

with:

```powershell
'economic and distributional impacts of'
'household energy transitions'
'clean energy access in promoting development and energy justice'
'vulnerable groups in developing countries, especially women and children'
```

- [ ] **Step 2: Run the verification script and confirm the new check fails**

Run: `powershell -ExecutionPolicy Bypass -File tests/verify-site.ps1`

Expected: FAIL with `Homepage is missing approved content: economic and distributional impacts of`.

- [ ] **Step 3: Commit the failing regression check**

```powershell
git add -- tests/verify-site.ps1
git commit -m "test: cover revised homepage research focus"
```

### Task 2: Replace the bilingual research-focus paragraph

**Files:**
- Modify: `index.html`
- Test: `tests/verify-site.ps1`

- [ ] **Step 1: Replace only the research-focus paragraph**

Use this HTML:

```html
<p><span data-en="My research focuses on the economic and distributional impacts of " data-zh="我的研究聚焦">My research focuses on the economic and distributional impacts of </span><strong data-en="household energy transitions" data-zh="家庭能源转型">household energy transitions</strong><span data-en=" and climate change, particularly the role of clean energy access in promoting development and energy justice for vulnerable groups in developing countries, especially women and children." data-zh="与气候变化的经济影响和分配效应，尤其关注清洁能源获取在促进发展中国家发展以及推动妇女和儿童等弱势群体能源正义方面的作用。"> and climate change, particularly the role of clean energy access in promoting development and energy justice for vulnerable groups in developing countries, especially women and children.</span></p>
```

- [ ] **Step 2: Run automated verification**

Run: `powershell -ExecutionPolicy Bypass -File tests/verify-site.ps1`

Expected: `Site verification passed.`

- [ ] **Step 3: Verify the rendered English and Chinese paragraph**

At 1440px and 390px widths, assert the full English sentence, full Chinese sentence, bold `household energy transitions`/`家庭能源转型`, and no horizontal overflow.

- [ ] **Step 4: Commit the homepage content change**

```powershell
git add -- index.html
git commit -m "content: refine homepage research focus"
```

### Task 3: Merge and publish

**Files:**
- Verify: `index.html`
- Verify: `tests/verify-site.ps1`

- [ ] **Step 1: Merge the tested feature branch into local `main`**

Run: `git merge --ff-only content/homepage-research-focus`

Expected: a fast-forward merge.

- [ ] **Step 2: Run final verification on `main`**

Run: `powershell -ExecutionPolicy Bypass -File tests/verify-site.ps1`

Expected: `Site verification passed.`

- [ ] **Step 3: Push the tested `main` branch**

Run: `git push origin main`

Expected: GitHub reports `main -> main`.

- [ ] **Step 4: Verify the deployed page**

Fetch `https://jiahuichen-99.github.io/index.html` without cache and confirm the approved research-focus fragments are present.
