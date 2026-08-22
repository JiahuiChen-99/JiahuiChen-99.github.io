# Academic Visual Refresh Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Redesign the three-page academic website with restrained typography, compact hierarchy, and content-first presentation.

**Architecture:** Keep the existing static HTML and bilingual JavaScript behavior. Replace the shared visual system in `assets/css/styles.css`, remove external font requests from all pages, and extend the existing static verification contract before implementation.

**Tech Stack:** HTML5, CSS, vanilla JavaScript, PowerShell verification, Playwright.

---

### Task 1: Define the visual contract

**Files:**
- Modify: `tests/verify-site.ps1`

- [ ] Require system sans-serif variables and moderate title sizes.
- [ ] Reject Google Fonts, serif display families, gradients, dotted texture backgrounds, and large card radii.
- [ ] Run the verification script and confirm the current design fails.

### Task 2: Remove external typography dependencies

**Files:**
- Modify: `index.html`
- Modify: `about.html`
- Modify: `research.html`

- [ ] Delete Google Fonts preconnect and stylesheet elements.
- [ ] Preserve the existing shared CSS and JavaScript references.

### Task 3: Implement the academic visual system

**Files:**
- Modify: `assets/css/styles.css`

- [ ] Replace font, color, background, spacing, and heading variables.
- [ ] Simplify the header, portrait, buttons, tags, timeline, honors, publications, and footer.
- [ ] Add compact tablet and mobile rules without increasing heading sizes dramatically.
- [ ] Run static verification and confirm it passes.

### Task 4: Browser verification and deployment

**Files:**
- No additional production files.

- [ ] Verify all pages at desktop and mobile widths with Playwright.
- [ ] Check bilingual switching, navigation, portrait, eight publications, no overflow, and no console errors.
- [ ] Commit only the web redesign files, excluding the locally modified PDF and Word source document.
- [ ] Push `main`, match local and remote commit IDs, and verify the public GitHub Pages CSS.
