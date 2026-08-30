# Homepage About Content Update Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace only the homepage biography and news content with the approved About Me, job-market, and January 2027 AEA information.

**Architecture:** Keep the existing static HTML structure, CSS classes, bilingual `data-en`/`data-zh` mechanism, and academic links. Add content assertions to the existing PowerShell verification script before changing `index.html`, then verify the English and Chinese states without changing any other page.

**Tech Stack:** HTML5, vanilla JavaScript data attributes, PowerShell verification

---

### Task 1: Add homepage content regression checks

**Files:**
- Modify: `tests/verify-site.ps1`
- Test: `tests/verify-site.ps1`

- [ ] **Step 1: Add failing assertions after `$homeHtml = $cleanPages['index.html']`**

```powershell
$requiredHomeContent = @(
    'data-en="About Me"'
    'Center for Energy and Environmental Policy Research (CEEP)'
    'empirical research about household energy transitions'
    'I am on the job market in 2027.'
    'Upcoming presentations and trips'
    'AEA Annual Meeting in Washington, D.C.'
    'January 2027'
)
foreach ($content in $requiredHomeContent) {
    if (-not $homeHtml.Contains($content)) {
        throw "Homepage is missing approved content: $content"
    }
}
```

- [ ] **Step 2: Run the test and confirm the new check fails**

Run: `powershell -ExecutionPolicy Bypass -File tests/verify-site.ps1`

Expected: FAIL with `Homepage is missing approved content: data-en="About Me"`.

- [ ] **Step 3: Commit the regression check**

```powershell
git add -- tests/verify-site.ps1
git commit -m "test: cover updated homepage biography"
```

### Task 2: Replace the homepage introduction and upcoming trip

**Files:**
- Modify: `index.html`
- Test: `tests/verify-site.ps1`

- [ ] **Step 1: Replace the homepage heading and biography inside `.profile-intro`**

Use this heading:

```html
<h1 id="hero-title" class="profile-name" data-en="About Me" data-zh="关于我">About Me</h1>
```

Replace the biography paragraphs before `.profile-links` with:

```html
<p data-en="Welcome to my website! I am Jiahui Chen. I have been a PhD candidate at the Center for Energy and Environmental Policy Research (CEEP), Beijing Institute of Technology (BIT), since 2021, under the supervision of Professor Hua Liao." data-zh="欢迎访问我的个人网站！我是陈佳慧。自 2021 年起，我在北京理工大学能源与环境政策研究中心（CEEP）攻读博士学位，导师为廖华教授。">Welcome to my website! I am Jiahui Chen. I have been a PhD candidate at the Center for Energy and Environmental Policy Research (CEEP), Beijing Institute of Technology (BIT), since 2021, under the supervision of Professor Hua Liao.</p>
<p><span data-en="My research interests lie in " data-zh="我的研究兴趣包括">My research interests lie in </span><strong data-en="empirical research about household energy transitions" data-zh="家庭能源转型的实证研究">empirical research about household energy transitions</strong><span data-en=", energy justice, and climate change economics, with a particular emphasis on risk-based explanations for variations in asset prices across international markets." data-zh="、能源公正和气候变化经济学，尤其关注基于风险的解释如何说明国际市场间资产价格的差异。">, energy justice, and climate change economics, with a particular emphasis on risk-based explanations for variations in asset prices across international markets.</span></p>
<p><strong data-en="I am on the job market in 2027." data-zh="我将于 2027 年进入学术求职市场。">I am on the job market in 2027.</strong></p>
```

- [ ] **Step 2: Replace the News section with the upcoming trip**

```html
<section class="plain-section" aria-labelledby="upcoming-title">
  <h2 id="upcoming-title" data-en="Upcoming presentations and trips" data-zh="近期报告与行程">Upcoming presentations and trips</h2>
  <ul class="news-list">
    <li><time datetime="2027-01">January 2027</time><span data-en="AEA Annual Meeting in Washington, D.C." data-zh="参加在美国华盛顿特区举行的美国经济学会年会（AEA Annual Meeting）。">AEA Annual Meeting in Washington, D.C.</span></li>
  </ul>
</section>
```

- [ ] **Step 3: Run the verification script**

Run: `powershell -ExecutionPolicy Bypass -File tests/verify-site.ps1`

Expected: `Site verification passed.`

- [ ] **Step 4: Confirm only the approved implementation files changed**

Run: `git diff --check -- index.html tests/verify-site.ps1` and `git diff --stat`

Expected: no whitespace errors; implementation changes are limited to `index.html` and `tests/verify-site.ps1`.

- [ ] **Step 5: Commit the homepage update**

```powershell
git add -- index.html
git commit -m "content: update homepage biography and travel"
```

### Task 3: Verify rendered bilingual behavior

**Files:**
- Verify: `index.html`
- Verify: `assets/js/site.js`

- [ ] **Step 1: Open the homepage at desktop and mobile widths**

Confirm that the portrait, About Me heading, three biography paragraphs, academic links, Education, and upcoming trip are readable with no horizontal overflow.

- [ ] **Step 2: Toggle the language control**

Confirm the heading, biography fragments including bold text, section title, and AEA item all switch to Chinese and back to English without losing emphasis or links.

- [ ] **Step 3: Run final verification**

Run: `powershell -ExecutionPolicy Bypass -File tests/verify-site.ps1`

Expected: `Site verification passed.`
