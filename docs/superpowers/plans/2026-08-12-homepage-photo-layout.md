# Homepage Photo and Content Refresh Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Correct the homepage portrait presentation and keep personal information separate from research content.

**Architecture:** Preserve the existing static HTML/CSS structure. Enforce the content and image-layout requirements in the PowerShell site contract, then make the smallest corresponding edits to `index.html` and `assets/css/styles.css`.

**Tech Stack:** HTML5, CSS, PowerShell static verification.

---

### Task 1: Add regression checks

**Files:**
- Modify: `tests/verify-site.ps1`

- [ ] Add assertions that `index.html` has no `focus-title`, `recent-title`, or `home-theme-grid` sections.
- [ ] Add assertions that the portrait rule uses `height: auto` and does not use a forced `aspect-ratio`.
- [ ] Run `powershell -ExecutionPolicy Bypass -File tests\\verify-site.ps1` and confirm it fails for the current homepage.

### Task 2: Simplify homepage and correct portrait layout

**Files:**
- Modify: `index.html`
- Modify: `assets/css/styles.css`

- [ ] Remove both research-oriented homepage sections while retaining the hero and footer.
- [ ] Change the portrait to a conventional rounded rectangle using its intrinsic dimensions and automatic height.
- [ ] Tune desktop and mobile hero spacing around the revised portrait.
- [ ] Run the site verification and confirm it passes.

### Task 3: Validate and publish

**Files:**
- No additional source files.

- [ ] Inspect the diff and run the complete site verification again.
- [ ] Commit the scoped changes.
- [ ] Push `main` to GitHub and verify local and remote commit IDs match.
- [ ] Confirm the deployed homepage contains the simplified structure.
