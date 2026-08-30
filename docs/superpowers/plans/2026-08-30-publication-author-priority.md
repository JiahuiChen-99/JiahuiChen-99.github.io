# Publication Author-Priority Ordering Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reorder all eight publications by Jiahui Chen’s authorship role, with descending year order inside each role group.

**Architecture:** Keep the static HTML structure and publication text unchanged. Add an exact sequence assertion to the PowerShell verification script, then move existing `<li>` elements into the specified order.

**Tech Stack:** Static HTML, PowerShell verification, GitHub Pages

---

### Task 1: Add an author-priority sequence check

**Files:**
- Modify: `tests/verify-site.ps1`
- Test: `tests/verify-site.ps1`

- [ ] **Step 1: Write the failing sequence test**

After `$researchHtml` is assigned, add an array containing the eight distinctive title fragments in the expected order. Loop over the fragments with `IndexOf`, requiring every match position to be greater than the preceding position; throw `Publications are not ordered by author priority` otherwise.

- [ ] **Step 2: Run the test to verify it fails**

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\verify-site.ps1
```

Expected: FAIL with `Publications are not ordered by author priority` because the current list is primarily year ordered.

- [ ] **Step 3: Commit the failing test**

```powershell
git add tests/verify-site.ps1
git commit -m "test: require author-priority publication order"
```

### Task 2: Reorder the publication list

**Files:**
- Modify: `research.html`
- Test: `tests/verify-site.ps1`

- [ ] **Step 1: Move the existing publication items into this sequence**

1. `Solar photovoltaic adoption and poverty alleviation`
2. `Global public perceptions of climate change risks`
3. `Empowering women substantially accelerates the household clean energy transition`
4. `Children’s Extracurricular Participation under Household Energy Transition`
5. `Rural photovoltaic projects substantially prompt household energy transition`
6. `Public pension accelerates the household electrification`
7. `Weather, Travel Modes, and the Effectiveness of Driving Restriction Policies`
8. `Decoupling carbon emissions, economic growth, and health costs`

Do not edit the contents of any `<li>`.

- [ ] **Step 2: Run the full verification suite**

```powershell
powershell -ExecutionPolicy Bypass -File tests\verify-site.ps1
git diff --check
```

Expected: `Site verification passed.` and both commands exit with code 0.

- [ ] **Step 3: Commit the implementation**

```powershell
git add research.html
git commit -m "content: prioritize publications by authorship role"
```

### Task 3: Publish and verify GitHub Pages

**Files:** None

- [ ] **Step 1: Push the main branch**

```powershell
git push origin main
```

Expected: `main -> main`.

- [ ] **Step 2: Verify the deployed title sequence**

Download `https://jiahuichen-99.github.io/research.html` with a cache-busting query string and apply the same ordered `IndexOf` checks. Expected: all eight title fragments appear in the required order.
