# CV PDF Replacement Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Publish the user-supplied English CV through the site’s existing stable `Resume_Chenjiahui.pdf` URL.

**Architecture:** Treat the PDF as a supplied binary asset, not generated code. Verify that the tracked public PDF is byte-identical to `Jiahui Chen_CV.pdf`, retain existing HTML links, commit only the tracked PDF, and verify the deployed file by SHA-256.

**Tech Stack:** PDF 1.7, Poppler `pdfinfo`/`pdftoppm`, PowerShell, GitHub Pages

---

### Task 1: Validate the supplied PDF and stable site link

**Files:**
- Verify: `Jiahui Chen_CV.pdf`
- Verify: `Resume_Chenjiahui.pdf`
- Verify: `index.html`
- Verify: `research.html`

- [ ] **Step 1: Compare local hashes**

Run:

```powershell
Get-FileHash -Algorithm SHA256 -LiteralPath 'Jiahui Chen_CV.pdf','Resume_Chenjiahui.pdf'
```

Expected: both hashes equal `3809115CF96FBDDE1F1BAFE5625717D1C7E0A4ABBA19F5794618CDA285EE8896`.

- [ ] **Step 2: Validate PDF structure**

Run: `pdfinfo 'Resume_Chenjiahui.pdf'`

Expected: 3 pages, A4 page size, PDF 1.7, not encrypted.

- [ ] **Step 3: Verify stable HTML links and site tests**

Run: `powershell -ExecutionPolicy Bypass -File tests/verify-site.ps1`

Expected: `Site verification passed.` and both pages continue linking to `Resume_Chenjiahui.pdf`.

### Task 2: Commit and publish the replacement PDF

**Files:**
- Modify: `Resume_Chenjiahui.pdf`

- [ ] **Step 1: Stage only the tracked public PDF**

```powershell
git add -- 'Resume_Chenjiahui.pdf'
git diff --cached --stat
```

Expected: the staged implementation contains only `Resume_Chenjiahui.pdf`.

- [ ] **Step 2: Commit and push**

```powershell
git commit -m "content: replace English CV"
git push origin main
```

- [ ] **Step 3: Verify deployed PDF**

Download `https://jiahuichen-99.github.io/Resume_Chenjiahui.pdf` with a cache-busting query string and compute SHA-256.

Expected: deployed hash equals `3809115CF96FBDDE1F1BAFE5625717D1C7E0A4ABBA19F5794618CDA285EE8896`.
